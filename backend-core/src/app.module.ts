// src/app.module.ts
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';
import { AppController } from './app.controller';
import { AlgorithmsController } from './algorithms/algorithms.controller';
import { AppService } from './app.service';
import { MoodcheckController } from './moodcheck/moodcheck.controller';
import { MoodcheckService } from './moodcheck/moodcheck.service';
import { AuthModule } from './auth/auth.module';
//import { UserModule } from './user/user.module';
import { EmailVerificationModule } from './email-verification/email-verification.module';
import { ProfileModule } from './profile/profile.module'; 
import { MoodcheckModule } from './moodcheck/moodcheck.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    MongooseModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        uri: configService.get<string>('MONGODB_URI'),
      }),
    }),
    AuthModule,
    //UserModule,
    EmailVerificationModule,
    ProfileModule,
    MoodcheckModule,
  ],
  controllers: [AppController, AlgorithmsController],
  providers: [AppService],
})
export class AppModule {}

