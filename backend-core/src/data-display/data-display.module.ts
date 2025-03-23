import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { DataDisplayController } from './data-display.controller';
import { DataDisplayService } from './data-display.service';
import { Mood, MoodSchema } from 'src/entities/mood.entity';

@Module({
    imports: [
      MongooseModule.forFeature([{ name: Mood.name, schema: MoodSchema }])
    ],
    controllers: [DataDisplayController],
    providers: [DataDisplayService],
    exports: [DataDisplayService]
  })
export class DataDisplayModule {}
