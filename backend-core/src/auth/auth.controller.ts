// src/auth/auth.controller.ts
import {
    Controller,
    Post,
    UseGuards,
    Request,
    Get,
    Headers,
    UnauthorizedException,
  } from '@nestjs/common';
  import { AuthGuard } from '@nestjs/passport';
  import { AuthService } from './auth.service';
  import { JwtAuthGuard } from './guards/jwt-auth.guard';
  
  @Controller('auth')
  export class AuthController {
    constructor(private authService: AuthService) {}
  
    @Get('profile')
    @UseGuards(JwtAuthGuard)
    async getProfile(@Request() req) {
      return req.user;
    }
  
    @Get('validate-token')
    async validateToken(@Headers('authorization') authHeader: string) {
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        throw new UnauthorizedException('Missing or invalid authorization header');
      }
  
      const token = authHeader.split(' ')[1];
      return this.authService.validateAuth0Token(token);
    }
  }
  
  