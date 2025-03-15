// src/profile/profile.controller.ts
import { Controller, Get, Post, Put, Delete, Param, Body, UseGuards, NotFoundException, BadRequestException } from '@nestjs/common';
import { ProfileService } from './profile.service';
import { AuthGuard } from '@nestjs/passport'; // Assuming AuthGuard is used to protect routes
import { Profile, ProfileDocument } from './entities/profile.entity';
import { Types } from 'mongoose';

// Create DTO for profile creation
interface CreateProfileDto {
  user: Types.ObjectId | string;
  email: string;
  name: string;
  picture?: string;
}

// Create DTO for profile update
interface UpdateProfileDto {
  name?: string;
  picture?: string;
  dateOfBirth?: Date;
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
  @Get('user/:userId')  // Endpoint to get profile by user ID
  async getProfile(@Param('userId') userId: string): Promise<ProfileDocument> {
    const objectId = this.validateObjectId(userId);
    const profile = await this.profileService.getProfileByUserId(objectId);
    
    if (!profile) {
      throw new NotFoundException(`Profile with user ID ${userId} not found`);
    }
    
    return profile;
  }

  @UseGuards(AuthGuard('jwt'))
  @Post()
  async createProfile(@Body() profileData: CreateProfileDto): Promise<ProfileDocument> {
    try {
      // Convert string ID to ObjectId if needed
      const userId = typeof profileData.user === 'string' 
        ? this.validateObjectId(profileData.user)
        : profileData.user;

      return this.profileService.createProfile({
        ...profileData,
        user: userId
      });
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
  @Delete(':profileId')
  async deleteProfile(@Param('profileId') profileId: string): Promise<void> {
    const objectId = this.validateObjectId(profileId);
    return this.profileService.deleteProfile(objectId);
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
}
