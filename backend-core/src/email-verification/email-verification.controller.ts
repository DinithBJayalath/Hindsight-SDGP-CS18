import { Controller, Post, Body, HttpException, HttpStatus } from '@nestjs/common';
import { EmailVerificationService } from './email-verification.service';

@Controller('email-verification')
export class EmailVerificationController {
  constructor(private readonly emailVerificationService: EmailVerificationService) {}

  @Post('send-code')
  async sendVerificationCode(@Body() body: { email: string }) {
    const { email } = body;
    
    if (!email) {
      throw new HttpException('Email is required', HttpStatus.BAD_REQUEST);
    }

    try {
      const code = await this.emailVerificationService.createVerificationCode(email);
      const sent = await this.emailVerificationService.sendVerificationEmail(email, code);
      
      if (!sent) {
        throw new HttpException('Failed to send verification email', HttpStatus.INTERNAL_SERVER_ERROR);
      }

      return { success: true, message: 'Verification code sent' };
    } catch (error) {
      throw new HttpException('Failed to process verification code', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @Post('verify-code')
  async verifyCode(@Body() body: { email: string; code: string }) {
    const { email, code } = body;
    
    if (!email || !code) {
      throw new HttpException('Email and code are required', HttpStatus.BAD_REQUEST);
    }

    try {
      const isValid = await this.emailVerificationService.verifyCode(email, code);
      
      if (!isValid) {
        return { success: false, message: 'Invalid or expired verification code' };
      }

      return { success: true, message: 'Email verified successfully' };
    } catch (error) {
      throw new HttpException('Failed to verify code', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }
}