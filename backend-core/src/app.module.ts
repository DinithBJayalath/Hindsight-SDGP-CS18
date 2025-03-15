import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AlgorithmsController } from './algorithms/algorithms.controller';
import { AppService } from './app.service';
import { MoodCheckController } from './mood-check/mood-check.controller';
import { MoodCheckService } from './mood-check/mood-check.service';

@Module({
  imports: [],
  controllers: [AppController, AlgorithmsController, MoodCheckController],
  providers: [AppService, MoodCheckService],
})
export class AppModule {}
