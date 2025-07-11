// src/auth/auth.controller.ts
import {
  Controller,
  Post,
  UseGuards,
  Request,
  Get,
  Headers,
  UnauthorizedException,
  Delete,
  HttpCode,
  Body,
  Patch,
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

  @Patch('update-name')
  @UseGuards(JwtAuthGuard)
  async updateUserName(@Request() req, @Body() body: { name: string }) {
    if (!req.user || !req.user.sub) {
      throw new UnauthorizedException('User ID not found in token');
    }
    
    if (!body.name) {
      throw new UnauthorizedException('Name is required');
    }
    
    return this.authService.updateUserName(req.user.sub, body.name);
  }

  @Delete('delete-account')
  @UseGuards(JwtAuthGuard)
  @HttpCode(200)
  async deleteAccount(@Request() req) {
    
    // Make sure we have a valid user ID
    if (!req.user || !req.user.sub) {
      throw new UnauthorizedException('User ID not found in token');
    }
    
    return this.authService.deleteAccount(req.user.sub);
  }
}