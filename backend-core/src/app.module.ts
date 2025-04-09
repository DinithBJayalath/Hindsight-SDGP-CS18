import { BreathingModule } from "./breathing/breathing.module";
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AppController } from './app.controller';
import { AlgorithmsController } from './algorithms/algorithms.controller';
import { AppService } from './app.service';
import { MoodcheckController } from './moodcheck/moodcheck.controller';
import { MoodcheckService } from './moodcheck/moodcheck.service';
import { MoodCheckDto } from './moodcheck/moodcheck.dto';
import { AuthModule } from './auth/auth.module';
import { EmailVerificationModule } from './email-verification/email-verification.module';
import { ProfileModule } from './profile/profile.module'; 
import { LettersModule } from "./letters/letters.module";
import { DrawingsModule } from "./drawings/drawings.module";
import { ActivitiesModule } from "./activities/activities/activities.module";
import { MongooseModule, MongooseModuleOptions } from "@nestjs/mongoose";

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    MongooseModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: async (configService: ConfigService): Promise<MongooseModuleOptions> => ({
        uri: configService.get<string>("MONGODB_URI"),
        dbName: configService.get<string>("MONGODB_DB_NAME"),
      }),
    }),
    AuthModule,
    EmailVerificationModule,
    ProfileModule,
    BreathingModule,
    LettersModule,
    DrawingsModule,
    ActivitiesModule,
    MoodcheckModule,
  ],
  controllers: [AppController, AlgorithmsController, MoodcheckController],
  providers: [AppService, MoodcheckService, MoodCheckDto],  // Add MoodCheckDto to providers if it's a DTO
})
export class AppModule {}
//