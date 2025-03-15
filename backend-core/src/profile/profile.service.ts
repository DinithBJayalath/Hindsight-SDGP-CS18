// src/profile/profile.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Profile, ProfileDocument } from './entities/profile.entity';
import { User, UserDocument } from '../user/entities/user.entity';

@Injectable()
export class ProfileService {
  constructor(
    @InjectModel('Profile') private readonly profileModel: Model<ProfileDocument>,
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
  ) {}

  async getProfileByUserId(userId: Types.ObjectId): Promise<ProfileDocument | null> {
    return this.profileModel.findOne({ user: userId }).exec();
  }

  async getProfileByEmail(email: string): Promise<ProfileDocument | null> {
    return this.profileModel.findOne({ email }).exec();
  }

  async createProfile(data: { user: Types.ObjectId; name: string; email: string; picture?: string }): Promise<ProfileDocument> {
    // Check if user exists
    const user = await this.userModel.findById(data.user).exec();
    if (!user) {
      throw new NotFoundException(`User with id ${data.user} not found`);
    }

    // Check if profile already exists
    const existingProfile = await this.getProfileByUserId(data.user);
    if (existingProfile) {
      return this.updateProfile(existingProfile._id, data);
    }

    // Create new profile
    const newProfile = new this.profileModel({
      user: data.user,
      email: data.email,
      name: data.name,
      picture: data.picture,
      isVerified: user.isVerified
    });

    return newProfile.save();
  }

  async updateProfile(
    profileId: Types.ObjectId,
    data: Partial<Profile>
  ): Promise<ProfileDocument> {
    const updatedProfile = await this.profileModel
      .findByIdAndUpdate(profileId, { $set: data }, { new: true })
      .exec();

    if (!updatedProfile) {
      throw new NotFoundException(`Profile with id ${profileId} not found`);
    }

    return updatedProfile;
  }

  async deleteProfile(profileId: Types.ObjectId): Promise<void> {
    const result = await this.profileModel.findByIdAndDelete(profileId).exec();
    
    if (!result) {
      throw new NotFoundException(`Profile with id ${profileId} not found`);
    }
  }
}
