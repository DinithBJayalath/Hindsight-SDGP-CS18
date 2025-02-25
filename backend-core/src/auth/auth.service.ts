// src/auth/auth.service.ts
import { Injectable, UnauthorizedException, Logger } from '@nestjs/common';
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
}

