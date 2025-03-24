import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Mood, MoodDocument } from '../schemas/mood_schemas';
import { CreateMoodDto } from '../dto/mood_dto';
import { EMOJI_MAP } from '../constants/emoji_map';

@Injectable()
export class MoodService {
  constructor(@InjectModel(Mood.name) private moodModel: Model<MoodDocument>) {}

  async findAll(userId: string, startDate: Date | null, endDate: Date | null): Promise<Mood[]> {
    // Build query with optional date filters
    let query: any = { userId: userId };
    
    if (startDate || endDate) {
      query.date = {};
      if (startDate) {
        query.date.$gte = startDate;
      }
      if (endDate) {
        query.date.$lte = endDate;
      }
    }
    
    return this.moodModel.find(query).lean().exec();
  }

  async create(createMoodDto: CreateMoodDto): Promise<Mood> {
    const { userId, mood, date, note } = createMoodDto;
    
    const createdMood = new this.moodModel({
      userId,
      mood,
      date: date ? new Date(date) : new Date(),
      note: note || '',
    });
    
    return createdMood.save();
  }

  async findByProfileId(profileId: string, startDate: Date | null, endDate: Date | null): Promise<any[]> {
    const filter = {
      profileId: new Types.ObjectId(profileId),
      entries: {
        $elemMatch: {}
      }
    };

    // Add date filters if provided
    if (startDate) {
      filter.entries.$elemMatch['createdAt'] = { $gte: startDate };
    }
    if (endDate) {
      filter.entries.$elemMatch['createdAt'] = { 
        ...filter.entries.$elemMatch['createdAt'],
        $lte: endDate
      };
    }

    const userMoods = await this.moodModel.findOne(filter, "entries").lean().exec();

    if (!userMoods || userMoods.entries.length === 0) {
      return [];
    }

    return userMoods.entries
      .filter(entry => 
        (!startDate || new Date(entry.createdAt) >= startDate) &&
        (!endDate || new Date(entry.createdAt) <= endDate)
      )
      .map(entry => ({
        date: entry.createdAt,
        mood: entry.mood || "-",
        emoji: EMOJI_MAP[entry.mood] || null
      }));
  }
}