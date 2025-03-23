// src/profile/profile.service.ts
import { Injectable, NotFoundException, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Profile, ProfileDocument } from '../entities/profile.entity';

@Injectable()
export class ProfileService {
  private readonly logger = new Logger(ProfileService.name);

  constructor(
    @InjectModel('Profile') private readonly profileModel: Model<ProfileDocument>,
  ) {}

  async getProfileByAuth0Id(auth0Id: string): Promise<ProfileDocument | null> {
    return this.profileModel.findOne({ auth0Id }).exec();
  }

  async getProfileByEmail(email: string): Promise<ProfileDocument | null> {
    return this.profileModel.findOne({ email }).exec();
  }

  async findById(id: string): Promise<ProfileDocument | null> {
    return this.profileModel.findOne({ auth0Id: id }).exec();
  }

  async findByEmail(email: string): Promise<ProfileDocument | null> {
    return this.profileModel.findOne({ email }).exec();
  }

  async findOrCreateUser(profileModel: any): Promise<ProfileDocument> {
      // First check by auth0Id which is the most reliable identifier
      let user = await this.findById(profileModel.sub);

      // If not found by auth0Id, try email as fallback
      if (!user && profileModel.email) {
        user = await this.findByEmail(profileModel.email);
      }

      if (!user) {
        this.logger.log(`Creating new user profile for: ${profileModel.email}`);
        return this.createProfile({
          auth0Id: profileModel.sub,
          email: profileModel.email,
          name: profileModel.name || '',
          picture: profileModel.picture || ''
        });
      } else {
        // Update existing user
        this.logger.log(`Updating existing user: ${user.email}`);
        return this.updateProfile(user._id, {
          email: profileModel.email,
          name: profileModel.name || user.name,
          picture: profileModel.picture || user.picture,
        });
      }
    
  }

  async createProfile(data: { auth0Id: string; name: string; email: string; picture?: string }): Promise<ProfileDocument> {
    try {
      // Check if profile already exists
      const existingProfile = await this.getProfileByAuth0Id(data.auth0Id);
      if (existingProfile) {
        return this.updateProfile(existingProfile._id, data);
      }

      // Create a new profile directly
      const newProfile = new this.profileModel({
        auth0Id: data.auth0Id,
        email: data.email,
        name: data.name,
        picture: data.picture,
        //user: new Types.ObjectId()
      });
      
      try {
        // Force the save with a transformed _id to avoid index conflicts
        return await newProfile.save();
      } catch (retryError) {
        this.logger.error(`Retry failed: ${retryError.message}`);
        
        // Last resort - try to update by auth0Id without the unique constraint
        try {
          await this.profileModel.collection.updateOne(
            { auth0Id: data.auth0Id },
            { 
              $set: {
                email: data.email,
                name: data.name,
                picture: data.picture,
                //user: new Types.ObjectId()
              }
            },
            { upsert: true }
          );
          
          // Now fetch the document
          const profile = await this.getProfileByAuth0Id(data.auth0Id);
          if (!profile) {
            throw new Error(`Failed to find profile after direct update: ${data.auth0Id}`);
          }
          
          return profile;
        } catch (finalError) {
          this.logger.error(`Final update attempt failed: ${finalError.message}`);
          throw finalError;
        }
      }
    } catch (error) {
      // Handle duplicate key error specifically
      if (error.message && error.message.includes('E11000 duplicate key error')) {
        this.logger.warn(`Duplicate key error for auth0Id: ${data.auth0Id}, email: ${data.email}`);
        
        // Try to find the profile again, there might be a race condition
        const existingProfile = await this.profileModel.findOne({
          $or: [{ auth0Id: data.auth0Id }, { email: data.email }]
        });
        
        if (existingProfile) {
          this.logger.log(`Found existing profile, updating instead`);
          return this.updateProfile(existingProfile._id, data);
        }
        
        // If we can't find the profile but get a duplicate error,
        // there's a unique index conflict - retry with a different approach
        this.logger.log(`Unique index conflict, retrying with direct update`);
        
        // Create a new profile directly
        const newProfile = new this.profileModel({
          auth0Id: data.auth0Id,
          email: data.email,
          name: data.name,
          picture: data.picture,
          user: new Types.ObjectId()
        });
        
        try {
          // Force the save with a transformed _id to avoid index conflicts
          return await newProfile.save();
        } catch (retryError) {
          this.logger.error(`Retry failed: ${retryError.message}`);
          
          // Last resort - try to update by auth0Id without the unique constraint
          try {
            await this.profileModel.collection.updateOne(
              { auth0Id: data.auth0Id },
              { 
                $set: {
                  email: data.email,
                  name: data.name,
                  picture: data.picture,
                  user: new Types.ObjectId()
                }
              },
              { upsert: true }
            );
            
            // Now fetch the document
            const profile = await this.getProfileByAuth0Id(data.auth0Id);
            if (!profile) {
              throw new Error(`Failed to find profile after direct update: ${data.auth0Id}`);
            }
            
            return profile;
          } catch (finalError) {
            this.logger.error(`Final update attempt failed: ${finalError.message}`);
            throw finalError;
          }
        }
      }
      
      // Re-throw if we couldn't handle it
      throw error;
    }
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

  async deleteProfile(auth0Id: string): Promise<void> {
    try {
      this.logger.log(`Attempting to delete profile with Auth0 ID: ${auth0Id}`);
      
      if (!auth0Id) {
        this.logger.error('Cannot delete profile with undefined Auth0 ID');
        return;
      }
      
      const result = await this.profileModel.findOneAndDelete({ auth0Id }).exec();
      
      if (!result) {
        this.logger.warn(`Profile with auth0Id ${auth0Id} not found`);
      } else {
        this.logger.log(`Successfully deleted profile: ${auth0Id}`);
      }
    } catch (error) {
      this.logger.error(`Error deleting profile: ${error.message}`);
      throw error;
    }
  }
}
