import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AlgorithmsController } from './algorithms/algorithms.controller';
import { AppService } from './app.service';
import { MoodcheckController } from './moodcheck/moodcheck.controller';
import { MoodcheckService } from './moodcheck/moodcheck.service';
import { MoodcheckModule } from './moodcheck/moodcheck.module';

@Module({
  imports: [MoodcheckModule],
  controllers: [AppController, AlgorithmsController, MoodcheckController],
  providers: [AppService, MoodcheckService],
})
export class AppModule {}
