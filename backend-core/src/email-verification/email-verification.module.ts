import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { MailerModule } from '@nestjs-modules/mailer';
import { HandlebarsAdapter } from '@nestjs-modules/mailer/dist/adapters/handlebars.adapter';
import { join } from 'path';
import { ConfigModule, ConfigService } from '@nestjs/config';

import { EmailVerificationController } from './email-verification.controller';
import { EmailVerificationService } from './email-verification.service';
import { VerificationCodeSchema } from './verification-code.schema';
import { ProfileSchema } from '../entities/profile.entity';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: 'VerificationCode', schema: VerificationCodeSchema },
      { name: 'Profile', schema: ProfileSchema },
    ]),
    MailerModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        transport: {
          host: configService.get('MAIL_HOST', 'smtp.gmail.com'),
          port: configService.get('MAIL_PORT', 587),
          secure: false, // false for 587, true for 465
          auth: {
            user: configService.get('MAIL_USER'),
            pass: configService.get('MAIL_PASSWORD'),
          },
          requireTLS: true,
          tls: {
            ciphers: 'SSLv3',
            rejectUnauthorized: false // Only set to false for debugging
          },
        },
        defaults: {
          from: `"No Reply" <${configService.get('MAIL_FROM', 'noreply@example.com')}>`,
        },
        template: {
          dir: join(__dirname, 'templates'),
          adapter: new HandlebarsAdapter(),
          options: {
            strict: true,
          },
        },
      }),
    }),
  ],
  controllers: [EmailVerificationController],
  providers: [EmailVerificationService],
  exports: [EmailVerificationService],
})
export class EmailVerificationModule {}