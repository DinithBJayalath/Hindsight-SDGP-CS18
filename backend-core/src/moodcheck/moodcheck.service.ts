import { Injectable, NotFoundException, Logger, BadRequestException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Mood, MoodDocument, MoodEntry } from '../entities/mood.entity';
import { MoodCheckDto } from './moodcheck.dto';

@Injectable()
export class MoodcheckService {
  private readonly logger = new Logger(MoodcheckService.name);
  
  constructor(
    @InjectModel(Mood.name) private moodModel: Model<MoodDocument>,
  ) {}

  async saveMood(profileId: string, moodData: MoodCheckDto): Promise<Mood> {
    try {
      
      if (!profileId) {
        throw new BadRequestException('Profile ID is required');
      }

      if (!moodData.mood) {
        throw new BadRequestException('Mood is required');
      }

      if (!moodData.emotion) {
        throw new BadRequestException('Emotion is required');
      }
      
      // Create a new mood entry with all required fields
      const newEntry: MoodEntry = {
        mood: moodData.mood,
        emotion: moodData.emotion,
        factors: moodData.factors || [],
        isJournal: moodData.isJournal || false,
        journalTitle: moodData.journalTitle || '',
        journalContent: moodData.journalContent || '',
        sentiment: moodData.sentiment || 0,
        createdAt: new Date()
      };

      // If this is a journal entry, log it
      if (moodData.isJournal) {
        this.logger.log(`Saving journal record with title: ${moodData.journalTitle}`);
      }
      
      // Find existing user mood document or create a new one
      const existingMood = await this.moodModel.findOne({ 
        profileId: new Types.ObjectId(profileId) 
      }).exec();
      
      if (existingMood) {
        // Update existing mood document by adding the new entry
        this.logger.log(`Found existing mood document for profile ${profileId}, adding new entry`);
        
        existingMood.entries.push(newEntry);
        existingMood.updatedAt = new Date();
        
        const updatedMood = await existingMood.save();
        this.logger.log(`${moodData.isJournal ? 'Journal' : 'Mood'} entry added to existing document with ID: ${updatedMood._id}`);
        return updatedMood;
      } else {
        // Create a new mood document for the user
        this.logger.log(`Creating new mood document for profile ${profileId}`);
        
        const newMood = new this.moodModel({
          profileId: new Types.ObjectId(profileId),
          entries: [newEntry],
          updatedAt: new Date()
        });
        
        const savedMood = await newMood.save();
        this.logger.log(`New mood document created with ID: ${savedMood._id} for ${moodData.isJournal ? 'journal' : 'mood'} entry`);
        return savedMood;
      }
    } catch (error) {
      this.logger.error(`Error saving ${moodData.isJournal ? 'journal' : 'mood'}: ${error.message}`);
      throw error;
    }
  }

  async getMoodsByProfileId(profileId: string): Promise<Mood[]> {
    // Now just returns the single document for the user
    const moodDocument = await this.moodModel.find({ 
      profileId: new Types.ObjectId(profileId) 
    }).exec();
    
    return moodDocument;
  }

  async getJournalsByProfileId(profileId: string): Promise<MoodEntry[]> {
    // Get the mood document
    const moodDocument = await this.moodModel.findOne({ 
      profileId: new Types.ObjectId(profileId) 
    }).exec();
    
    if (!moodDocument) {
      return [];
    }
    
    // Filter only journal entries
    return moodDocument.entries.filter(entry => entry.isJournal);
  }

  async getMoodById(moodId: string): Promise<Mood> {
    const mood = await this.moodModel.findById(moodId).exec();
    
    if (!mood) {
      throw new NotFoundException(`Mood with ID ${moodId} not found`);
    }
    
    return mood;
  }

  async deleteMood(moodId: string): Promise<void> {
    const result = await this.moodModel.deleteOne({ _id: moodId }).exec();
    
    if (result.deletedCount === 0) {
      throw new NotFoundException(`Mood with ID ${moodId} not found`);
    }
  }
  
  // Add a new method to delete a specific mood entry
  async deleteMoodEntry(profileId: string, entryIndex: number): Promise<Mood> {
    const mood = await this.moodModel.findOne({ 
      profileId: new Types.ObjectId(profileId) 
    }).exec();
    
    if (!mood) {
      throw new NotFoundException(`Mood document for profile ID ${profileId} not found`);
    }
    
    if (entryIndex < 0 || entryIndex >= mood.entries.length) {
      throw new BadRequestException(`Invalid entry index: ${entryIndex}`);
    }
    
    // Remove the entry at the specified index
    mood.entries.splice(entryIndex, 1);
    mood.updatedAt = new Date();
    
    return mood.save();
  }
}
