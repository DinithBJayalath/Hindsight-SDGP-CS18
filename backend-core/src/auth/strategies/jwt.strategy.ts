// src/auth/strategies/jwt.strategy.ts
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { passportJwtSecret } from 'jwks-rsa';
import { AuthService } from '../auth.service';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    private configService: ConfigService,
    private authService: AuthService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKeyProvider: passportJwtSecret({
        cache: true,
        rateLimit: true,
        jwksRequestsPerMinute: 5,
        jwksUri: `https://${configService.get<string>('AUTH0_DOMAIN')}/.well-known/jwks.json`,
      }),
      audience: configService.get<string>('AUTH0_AUDIENCE'),
      issuer: `https://${configService.get<string>('AUTH0_DOMAIN')}/`,
      algorithms: ['RS256'],
    });
  }

  async validate(payload: any) {
    // Ensure the payload contains a valid sub claim (Auth0 user ID)
    if (!payload || !payload.sub) {
      throw new UnauthorizedException('Invalid token: missing user identifier');
    }
    
    console.log('JWT payload:', JSON.stringify(payload));
    
    // First, validate the user with our service
    const user = await this.authService.validateUser(payload);
    console.log('User from DB:', JSON.stringify(user));
    
    if (!user || !user._id) {
      throw new UnauthorizedException('User not found or invalid');
    }
    
    // Ensure we always return the Auth0 user ID (sub) and profile ID with the user object
    return {
      ...user,
      sub: payload.sub, // Ensure sub is always included in the request.user object
      profileId: user._id.toString() // Explicitly include profileId as a string
    };
  }
}
