import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AlgorithmsController } from './algorithms/algorithms.controller';
import { AppService } from './app.service';

@Module({
  imports: [],
  controllers: [AppController, AlgorithmsController],
  providers: [AppService],
})
export class AppModule {}
