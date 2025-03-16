import { Injectable, UnauthorizedException, Logger, InternalServerErrorException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import axios from 'axios';
import * as jwksRsa from 'jwks-rsa';
import * as jwt from 'jsonwebtoken';
import { UserService } from '../user/user.service';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);
  private jwksClient: jwksRsa.JwksClient;

  constructor(
    private jwtService: JwtService,
    private configService: ConfigService,
    private userService: UserService,
  ) {
    this.jwksClient = jwksRsa({
      jwksUri: `https://${this.configService.get<string>('AUTH0_DOMAIN')}/.well-known/jwks.json`,
      cache: true,
      rateLimit: true,
      jwksRequestsPerMinute: 5,
    });
  }

  async validateAuth0Token(token: string): Promise<any> {
    try {
      const decodedToken: any = jwt.decode(token, { complete: true });
      if (!decodedToken) {
        throw new UnauthorizedException('Invalid token');
      }

      const kid = decodedToken.header.kid;
      const key = await this.jwksClient.getSigningKey(kid);
      const signingKey = key.getPublicKey();

      const verified = jwt.verify(token, signingKey, {
        algorithms: ['RS256'],
        audience: this.configService.get<string>('AUTH0_AUDIENCE'),
        issuer: `https://${this.configService.get<string>('AUTH0_DOMAIN')}/`,
      });

      // Get user info from Auth0 or create user if not exists
      const userProfile = await this.getUserProfile(token);
      const user = await this.userService.findOrCreateUser(userProfile);

      return { verified, user };
    } catch (error) {
      this.logger.error(`Token validation error: ${error.message}`);
      throw new UnauthorizedException('Invalid token');
    }
  }

  async getUserProfile(token: string): Promise<any> {
    try {
      const response = await axios.get(
        `https://${this.configService.get<string>('AUTH0_DOMAIN')}/userinfo`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        },
      );
      return response.data;
    } catch (error) {
      this.logger.error(`Error fetching user profile: ${error.message}`);
      throw new UnauthorizedException('Failed to fetch user profile');
    }
  }

  async validateUser(payload: any): Promise<any> {
    const user = await this.userService.findById(payload.sub);
    if (!user) {
      throw new UnauthorizedException('User not found');
    }
    return user;
  }

  async deleteAccount(userId: string) {
    try {
      this.logger.log(`Starting account deletion for user: ${userId}`);
      
      if (!userId) {
        throw new Error('User ID is required for account deletion');
      }
      
      // Ensure proper formatting of Auth0 user ID
      // Auth0 user IDs typically start with 'auth0|', 'google-oauth2|', etc.
      const formattedUserId = userId.includes('|') ? userId : `auth0|${userId}`;
      this.logger.log(`Formatted user ID for Auth0: ${formattedUserId}`);
      
      // 1. Get Auth0 Management API token
      const auth0Domain = this.configService.get<string>('AUTH0_DOMAIN');
      const clientId = this.configService.get<string>('AUTH0_BACKEND_CLIENT_ID');
      const clientSecret = this.configService.get<string>('AUTH0_BACKEND_CLIENT_SECRET');
      
      this.logger.log(`Using client ID: ${clientId}, domain: ${auth0Domain}`);
      
      try {
        // Get management API token
        this.logger.log('Getting Auth0 Management API token');
        const tokenResponse = await axios.post(
          `https://${auth0Domain}/oauth/token`,
          {
            client_id: clientId,
            client_secret: clientSecret,
            audience: `https://${auth0Domain}/api/v2/`,
            grant_type: 'client_credentials',
          },
          {
            headers: { 'content-type': 'application/json' },
          }
        );

        if (!tokenResponse.data || !tokenResponse.data.access_token) {
          throw new Error('No access token received from Auth0');
        }

        const managementApiToken = tokenResponse.data.access_token;
        this.logger.log('Successfully obtained Auth0 Management API token');

        // 2. Delete user from Auth0
        this.logger.log(`Deleting user from Auth0: ${formattedUserId}`);
        await axios.delete(`https://${auth0Domain}/api/v2/users/${encodeURIComponent(formattedUserId)}`, {
          headers: {
            Authorization: `Bearer ${managementApiToken}`,
          },
        });
        this.logger.log(`Successfully deleted user from Auth0: ${formattedUserId}`);
      } catch (auth0Error) {
        this.logger.error(`Auth0 deletion error: ${auth0Error.message}`);
        if (auth0Error.response) {
          this.logger.error(`Auth0 response: ${JSON.stringify(auth0Error.response.data)}`);
        }
        
        // If the error is 404 (user not found), we continue with deleting from our DB
        if (!(auth0Error.response && auth0Error.response.status === 404)) {
          throw auth0Error;
        } else {
          this.logger.warn(`User not found in Auth0, continuing with database deletion`);
        }
      }

      // 3. Delete user from our database
      await this.userService.deleteUser(userId);

      this.logger.log(`Successfully deleted user ${userId}`);
      return { success: true, message: 'Account deleted successfully' };
    } catch (error) {
      this.logger.error(`Failed to delete account: ${error.message}`);
      throw new InternalServerErrorException('Failed to delete account');
    }
  }
}