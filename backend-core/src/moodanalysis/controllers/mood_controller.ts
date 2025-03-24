import { Controller, Get, Post, Body, Query, Param, HttpException, HttpStatus } from '@nestjs/common';
import { MoodService } from '../services/mood_services';
import { Types } from 'mongoose';
import { CreateMoodDto } from '../dto/mood_dto';

@Controller('moods')
export class MoodController {
  constructor(private readonly moodService: MoodService) {}

  @Get()
  async getAllMoods(@Query('userId') userId: string, @Query('start') start: string, @Query('end') end: string) {
    // Validate userId is provided
    if (!userId) {
      throw new HttpException('userId is required', HttpStatus.BAD_REQUEST);
    }
    
    try {
      const startDate = start ? new Date(start) : null;
      const endDate = end ? new Date(end) : null;
      
      // Validate dates if provided
      if (startDate && isNaN(startDate.getTime())) {
        throw new HttpException('Invalid start date', HttpStatus.BAD_REQUEST);
      }
      if (endDate && isNaN(endDate.getTime())) {
        throw new HttpException('Invalid end date', HttpStatus.BAD_REQUEST);
      }
      
      const userMoods = await this.moodService.findAll(userId, startDate, endDate);
      
      return {
        success: true,
        data: userMoods
      };
    } catch (error) {
      throw new HttpException(error.message, HttpStatus.BAD_REQUEST);
    }
  }

  @Post()
  async createMood(@Body() createMoodDto: CreateMoodDto) {
    try {
      const newMood = await this.moodService.create(createMoodDto);
      return {
        success: true,
        data: newMood
      };
    } catch (error) {
      throw new HttpException(error.message, HttpStatus.BAD_REQUEST);
    }
  }

  @Get(':profileId')
  async getMoodsByProfileId(
    @Param('profileId') profileId: string,
    @Query('start') start: string,
    @Query('end') end: string
  ) {
    // Validate profileId format
    if (!Types.ObjectId.isValid(profileId)) {
      throw new HttpException('Invalid profileId format', HttpStatus.BAD_REQUEST);
    }

    const startDate = start ? new Date(start) : null;
    const endDate = end ? new Date(end) : null;

    // Validate dates if provided
    if (startDate && isNaN(startDate.getTime())) {
      throw new HttpException('Invalid start date', HttpStatus.BAD_REQUEST);
    }
    if (endDate && isNaN(endDate.getTime())) {
      throw new HttpException('Invalid end date', HttpStatus.BAD_REQUEST);
    }

    try {
      const moodData = await this.moodService.findByProfileId(profileId, startDate, endDate);
      
      if (!moodData || moodData.length === 0) {
        throw new HttpException('No moods found', HttpStatus.NOT_FOUND);
      }

      return {
        success: true,
        data: moodData
      };
    } catch (error) {
      if (error.status === HttpStatus.NOT_FOUND) {
        throw error;
      }
      throw new HttpException(error.message, HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }
}