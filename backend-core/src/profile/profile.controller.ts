// src/profile/profile.controller.ts
import { Controller, Get, Post, Put, Delete, Param, Body, UseGuards, NotFoundException } from '@nestjs/common';
import { ProfileService } from './profile.service';
import { AuthGuard } from '@nestjs/passport'; // Assuming AuthGuard is used to protect routes
import { Profile } from './entities/profile.entity';

@Controller('profile')
export class ProfileController {
  constructor(private readonly profileService: ProfileService) {}

  // Use JWT Authentication to protect this route
  @UseGuards(AuthGuard('jwt')) 
  @Get(':email')  // Endpoint to get profile by email
  async getProfile(@Param('email') email: string): Promise<Profile> {
    const profile = await this.profileService.getProfileByEmail(email);
    
    if (!profile) {
      throw new NotFoundException(`Profile with email ${email} not found`);
    }
    
    return profile;
  }

  @UseGuards(AuthGuard('jwt'))
  @Post()
  async createProfile(@Body() profileData: Partial<Profile>): Promise<Profile> {
    return this.profileService.createProfile(profileData);
  }

  @UseGuards(AuthGuard('jwt'))
  @Put(':email')
  async updateProfile(
    @Param('email') email: string,
    @Body() profileData: Partial<Profile>
  ): Promise<Profile> {
    return this.profileService.updateProfile(email, profileData);
  }

  @UseGuards(AuthGuard('jwt'))
  @Delete(':email')
  async deleteProfile(@Param('email') email: string): Promise<void> {
    return this.profileService.deleteProfile(email);
  }
}
