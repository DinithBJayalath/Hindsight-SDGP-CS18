// src/profile/profile.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Profile, ProfileDocument } from './entities/profile.entity';
import { User } from '../user/entities/user.entity';

@Injectable()
export class ProfileService {
  constructor(
    @InjectModel('Profile') private readonly profileModel: Model<ProfileDocument>,
    @InjectModel('User') private readonly userModel: Model<User>,
  ) {}

  async getProfileByEmail(email: string): Promise<Profile | null> {
    const profile = await this.profileModel.findOne({ email }).exec();
    return profile;
  }

  async createProfile(profileData: Partial<Profile>): Promise<Profile> {
    // Check if user exists first
    const user = await this.userModel.findOne({ email: profileData.email }).exec();
    
    if (!user) {
      throw new NotFoundException(`User with email ${profileData.email} not found`);
    }

    // Create profile with data from user
    const newProfile = new this.profileModel({
      _id: profileData.email, // Use email as the profile ID
      email: profileData.email,
      name: user.name,
      picture: user.picture || '',
      isVerified: user.isVerified,
      ...profileData
    });

    return newProfile.save();
  }

  async updateProfile(email: string, profileData: Partial<Profile>): Promise<Profile> {
    const updatedProfile = await this.profileModel.findOneAndUpdate(
      { email },
      { ...profileData },
      { new: true }
    ).exec();

    if (!updatedProfile) {
      throw new NotFoundException(`Profile with email ${email} not found`);
    }

    return updatedProfile;
  }

  async deleteProfile(email: string): Promise<void> {
    const result = await this.profileModel.deleteOne({ email }).exec();
    
    if (result.deletedCount === 0) {
      throw new NotFoundException(`Profile with email ${email} not found`);
    }
  }
}
