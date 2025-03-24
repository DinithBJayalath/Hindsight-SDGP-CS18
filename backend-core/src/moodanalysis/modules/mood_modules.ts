import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { MoodController } from '../controllers/mood_controller';
import { MoodService } from '../services/mood_services';
import { Mood, MoodSchema } from '../schemas/mood_schemas';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Mood.name, schema: MoodSchema }])
  ],
  controllers: [MoodController],
  providers: [MoodService],
  exports: [MoodService]
})
export class MoodModule {}