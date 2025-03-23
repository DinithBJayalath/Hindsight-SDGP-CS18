import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Mood, MoodDocument } from 'src/entities/mood.entity';


@Injectable()
export class DataDisplayService {
    constructor(
        @InjectModel(Mood.name) private moodModel: Model<MoodDocument>
      ) {}

    async findAll(userId: string): Promise<{ mood: string; createdAt: Date }[]> {
        const result = await this.moodModel.findOne(
            { profileId: userId }, 
            { entries: 1, _id: 0 } 
          ).lean();
        
        if (!result || !result.entries) return [];
        
        return result.entries.map(entry => ({
            mood: entry.mood,
            createdAt: entry.createdAt,
        }));
    }

}
