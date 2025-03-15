// src/user/user.service.ts
import { Injectable, Inject, forwardRef } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from './entities/user.entity';
import { ProfileService } from '../profile/profile.service';

@Injectable()
export class UserService {
  constructor(
    @InjectModel(User.name) private readonly userModel: Model<User>,
    @Inject(forwardRef(() => ProfileService))
    private readonly profileService: ProfileService,
  ) {}

  async findById(id: string): Promise<User | null> {
    return this.userModel.findOne({ auth0Id: id }).exec();
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.userModel.findOne({ email }).exec();
  }

  async findOrCreateUser(userProfile: any): Promise<User> {
    let user = await this.findById(userProfile.sub);

    if (!user) {
      user = await this.userModel.create({
        auth0Id: userProfile.sub,
        email: userProfile.email,
        name: userProfile.name || '',
        picture: userProfile.picture || '',
      });

      // Create profile for new user
      await this.profileService.createProfile({
        email: user.email,
        name: user.name,
        picture: user.picture,
      });
    } else {
      // Update user information if needed
      user.email = userProfile.email;
      user.name = userProfile.name || user.name;
      user.picture = userProfile.picture || user.picture;
      await user.save();

      // Update profile if it exists
      const profile = await this.profileService.getProfileByEmail(user.email);
      if (profile) {
        await this.profileService.updateProfile(user.email, {
          name: user.name,
          picture: user.picture,
        });
      } else {
        // Create profile if it doesn't exist
        await this.profileService.createProfile({
          email: user.email,
          name: user.name,
          picture: user.picture,
        });
      }
    }

    return user;
  }
}

