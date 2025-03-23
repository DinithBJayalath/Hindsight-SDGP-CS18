import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { MoodcheckController } from './moodcheck.controller';
import { MoodcheckService } from './moodcheck.service';
import { Mood, MoodSchema } from '../entities/mood.entity';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Mood.name, schema: MoodSchema }])
  ],
  controllers: [MoodcheckController],
  providers: [MoodcheckService],
  exports: [MoodcheckService]
})
export class MoodcheckModule {}
