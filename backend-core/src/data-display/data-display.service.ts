import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Mood, MoodDocument } from 'src/entities/mood.entity';


@Injectable()
export class DataDisplayService {
    constructor(
        @InjectModel(Mood.name) private moodModel: Model<MoodDocument>
      ) {}

    async findAll(userId: string): Promise<string[]> {
        const moods = await this.moodModel.find({ profileId: userId }).exec();
        return moods.flatMap(mood => mood.entries.map(entry => entry.mood));
    }

}
