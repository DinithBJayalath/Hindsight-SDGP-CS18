import { Module } from "@nestjs/common";
import { ConfigModule, ConfigService } from "@nestjs/config";
import { MongooseModule, MongooseModuleOptions } from "@nestjs/mongoose";
import { ActivitiesModule } from "./activities/activities/activities.module";
import { DrawingsModule } from "./drawings/drawings.module";
import { LettersModule } from "./letters/letters.module";
import { BreathingModule } from "./breathing/breathing.module";

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    MongooseModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: async (
        configService: ConfigService
      ): Promise<MongooseModuleOptions> => ({
        uri: configService.get<string>("MONGODB_URI"),
        dbName: configService.get<string>("MONGODB_DB_NAME"),
      }),
      inject: [ConfigService],
    }),
    ActivitiesModule,
    DrawingsModule,
    LettersModule,
    BreathingModule,
  ],
})
export class AppModule {}
