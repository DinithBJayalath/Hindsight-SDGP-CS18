// src/user/user.service.ts
import { Injectable, Inject, forwardRef, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { User, UserDocument } from './entities/user.entity';
import { ProfileService } from '../profile/profile.service';

@Injectable()
export class UserService {
  constructor(
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
    @Inject(forwardRef(() => ProfileService))
    private readonly profileService: ProfileService,
  ) {}

  async findById(id: string): Promise<UserDocument | null> {
    return this.userModel.findOne({ auth0Id: id }).exec();
  }

  async findByEmail(email: string): Promise<UserDocument | null> {
    return this.userModel.findOne({ email }).exec();
  }

  async findOrCreateUser(userProfile: any): Promise<UserDocument> {
    let user = await this.findById(userProfile.sub);

    if (!user) {
      // Create new user
      const newUser = await this.userModel.create({
        auth0Id: userProfile.sub,
        email: userProfile.email,
        name: userProfile.name || '',
        picture: userProfile.picture || '',
        isVerified: false
      });

      // Create a new profile and link it using ObjectId
      const profile = await this.profileService.createProfile({
        user: newUser._id,
        email: newUser.email,
        name: newUser.name,
        picture: newUser.picture
      });

      // Update user with profile reference
      await this.userModel.findByIdAndUpdate(newUser._id, {
        profile: profile._id
      });

      const updatedNewUser = await this.userModel.findById(newUser._id).exec();
      if (!updatedNewUser) {
        throw new NotFoundException(`User not found after creation`);
      }
      return updatedNewUser;
    } else {
      // Update existing user
      const updates = {
        email: userProfile.email,
        name: userProfile.name || user.name,
        picture: userProfile.picture || user.picture,
      };
      
      const updatedUser = await this.userModel.findByIdAndUpdate(
        user._id,
        { $set: updates },
        { new: true }
      ).exec();

      if (!updatedUser) {
        throw new Error('Failed to update user');
      }

      // Update or create profile
      if (updatedUser.profile) {
        await this.profileService.updateProfile(updatedUser.profile, {
          name: updatedUser.name,
          picture: updatedUser.picture,
        });
      } else {
        const newProfile = await this.profileService.createProfile({
          user: updatedUser._id,
          email: updatedUser.email,
          name: updatedUser.name,
          picture: updatedUser.picture
        });

        await this.userModel.findByIdAndUpdate(updatedUser._id, {
          profile: newProfile._id
        });
      }

      const finalUser = await this.userModel.findById(updatedUser._id).exec();
      if (!finalUser) {
        throw new NotFoundException(`User not found after update`);
      }
      return finalUser;
    }
  }
}

