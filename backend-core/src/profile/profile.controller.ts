// src/profile/profile.controller.ts
import { Controller, Get, Post, Put, Delete, Param, Body, UseGuards, NotFoundException, BadRequestException } from '@nestjs/common';
import { ProfileService } from './profile.service';
import { AuthGuard } from '@nestjs/passport'; // Assuming AuthGuard is used to protect routes
import { ProfileDocument } from '../entities/profile.entity';
import { Types } from 'mongoose';

// Create DTO for profile creation
interface CreateProfileDto {
  auth0Id: string;
  email: string;
  name: string;
  picture?: string;
}

// Create DTO for profile update
interface UpdateProfileDto {
  name?: string;
  picture?: string;
  country?: string;
  city?: string;
  bio?: string;
  biometricAuthentication?: boolean;
  cloudBackup?: boolean;
  pushNotifications?: boolean;
  language?: string;
}

@Controller('profile')
export class ProfileController {
  constructor(private readonly profileService: ProfileService) {}

  private validateObjectId(id: string): Types.ObjectId {
    try {
      if (!Types.ObjectId.isValid(id)) {
        throw new BadRequestException('Invalid ID format');
      }
      return new Types.ObjectId(id);
    } catch (error) {
      throw new BadRequestException('Invalid ID format');
    }
  }

  // Use JWT Authentication to protect this route
  @UseGuards(AuthGuard('jwt')) 
  @Get('auth0/:auth0Id')  // Endpoint to get profile by Auth0 ID
  async getProfile(@Param('auth0Id') auth0Id: string): Promise<ProfileDocument> {
    const profile = await this.profileService.getProfileByAuth0Id(auth0Id);
    
    if (!profile) {
      throw new NotFoundException(`Profile with Auth0 ID ${auth0Id} not found`);
    }
    
    return profile;
  }

  @UseGuards(AuthGuard('jwt'))
  @Post()
  async createProfile(@Body() profileData: CreateProfileDto): Promise<ProfileDocument> {
    try {
      return this.profileService.createProfile(profileData);
    } catch (error) {
      if (error instanceof BadRequestException) {
        throw error;
      }
      throw new BadRequestException('Invalid profile data');
    }
  }

  @UseGuards(AuthGuard('jwt'))
  @Put(':profileId')
  async updateProfile(
    @Param('profileId') profileId: string,
    @Body() profileData: UpdateProfileDto
  ): Promise<ProfileDocument> {
    const objectId = this.validateObjectId(profileId);
    return this.profileService.updateProfile(objectId, profileData);
  }

  @UseGuards(AuthGuard('jwt'))
  @Delete('auth0/:auth0Id')
  async deleteProfile(@Param('auth0Id') auth0Id: string): Promise<void> {
    return this.profileService.deleteProfile(auth0Id);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('email/:email')
  async getProfileByEmail(@Param('email') email: string): Promise<ProfileDocument> {
    const profile = await this.profileService.getProfileByEmail(email);
    
    if (!profile) {
      throw new NotFoundException(`Profile with email ${email} not found`);
    }
    
    return profile;
  }

  @Get('check-email/:email')
  async checkEmailExists(@Param('email') email: string) {
    const exists = await this.profileService.findByEmail(email);
    if (exists) {
      return { exists: true };
    }
    return { exists: false };
  }
}
