import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { MailerService } from '@nestjs-modules/mailer';
import * as crypto from 'crypto';

// You'll need to create this schema
interface VerificationCode {
  email: string;
  code: string;
  createdAt: Date;
  expiresAt: Date;
}

@Injectable()
export class EmailVerificationService {
  constructor(
    @InjectModel('VerificationCode') private verificationCodeModel: Model<VerificationCode>,
    private readonly mailerService: MailerService,
  ) {}

  /**
   * Generate a random 6-digit code
   */
  private generateVerificationCode(): string {
    return Math.floor(100000 + Math.random() * 900000).toString();
  }

  /**
   * Create and save a verification code for the given email
   */
  async createVerificationCode(email: string): Promise<string> {
    // Delete any existing codes for this email
    await this.verificationCodeModel.deleteMany({ email });

    // Generate a new code
    const code = this.generateVerificationCode();
    
    // Create an expiration date (15 minutes from now)
    const expiresAt = new Date();
    expiresAt.setMinutes(expiresAt.getMinutes() + 15);

    // Save the code to the database
    await this.verificationCodeModel.create({
      email,
      code,
      createdAt: new Date(),
      expiresAt,
    });

    return code;
  }

  /**
   * Send verification email with the code
   */
  async sendVerificationEmail(email: string, code: string): Promise<boolean> {
    try {
      await this.mailerService.sendMail({
        to: email,
        subject: 'Email Verification Code',
        template: 'verification-code', // Create this template in your mailer templates folder
        context: {
          code,
          expirationMinutes: 15,
        },
      });
      return true;
    } catch (error) {
      console.error('Failed to send verification email:', error);
      return false;
    }
  }

  /**
   * Verify a code for a given email
   */
  async verifyCode(email: string, code: string): Promise<boolean> {
    const verificationRecord = await this.verificationCodeModel.findOne({
      email,
      code,
      expiresAt: { $gt: new Date() }, // Make sure the code hasn't expired
    });

    return !!verificationRecord; // Return true if a valid record was found
  }
}