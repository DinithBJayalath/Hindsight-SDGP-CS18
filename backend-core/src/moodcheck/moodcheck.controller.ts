import { 
  Body, 
  Controller,
  Get,
  Post,
  Delete,
  Param,
  UseGuards,
  Request,
  Logger,
  BadRequestException,
  Query
} from '@nestjs/common';
import { MoodCheckDto } from './moodcheck.dto';
import { MoodcheckService } from './moodcheck.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { analyzeJournalRecord } from '../algorithms/algorithms.client';

@Controller('moodcheck')
export class MoodcheckController {
  private readonly logger = new Logger(MoodcheckController.name);
  
  constructor(private readonly moodcheckService: MoodcheckService) {}
    
    @Get()
  @UseGuards(JwtAuthGuard)
  async getUserMoods(@Request() req) {
    const profileId = req.user.profileId;
    return this.moodcheckService.getMoodsByProfileId(profileId);
  }
  
  @Get('journals')
  @UseGuards(JwtAuthGuard)
  async getUserJournals(@Request() req) {
    const profileId = req.user.profileId;
    return this.moodcheckService.getJournalsByProfileId(profileId);
  }
    
  @Get(':id')
  @UseGuards(JwtAuthGuard)
  async getMoodById(@Param('id') id: string, @Request() req) {
    const mood = await this.moodcheckService.getMoodById(id);
    // Ensure user can only access their own mood entries
    if (mood.profileId.toString() !== req.user.profileId) {
      throw new Error('Unauthorized access to mood data');
    }
    return mood;
  }
    
    @Post()
  @UseGuards(JwtAuthGuard)
  async saveMood(@Body() data: MoodCheckDto, @Request() req) {
    try {
      this.logger.log(`Received mood data: ${JSON.stringify(data)}`);
      // Log entire user object from request to understand what we're receiving
      this.logger.log(`User in request: ${JSON.stringify(req.user)}`);
      
      const profileId = req.user.profileId;
      this.logger.log(`Extracted profile ID: ${profileId}`);
      
      if (!profileId) {
        this.logger.error('Profile ID is missing in the request');
        throw new BadRequestException('Profile ID is required');
      }
      
      return await this.moodcheckService.saveMood(profileId, data);
    } catch (error) {
      this.logger.error(`Error saving mood: ${error.message}`);
      this.logger.error(`Error stack: ${error.stack}`);
      throw error;
    }
  }
  
  @Post('journal')
  @UseGuards(JwtAuthGuard)
  async saveJournalRecord(@Body() data: any, @Request() req) {
    try {
      this.logger.log(`Received journal data: ${JSON.stringify({
        title: data.title,
        content: data.content ? data.content.substring(0, 50) + '...' : 'No content'
      })}`);
      
      const profileId = req.user.profileId;
      
      if (!profileId) {
        throw new BadRequestException('Profile ID is required');
      }
      
      if (!data.content) {
        throw new BadRequestException('Journal content is required');
      }
      
      // Analyze the journal content to get mood, emotion and sentiment
      const analysis = await analyzeJournalRecord(data.content);
      this.logger.log(`Journal analysis results: ${JSON.stringify(analysis)}`);
      
      // Create a MoodCheckDto with journal data
      const journalMoodData: MoodCheckDto = {
        mood: analysis.mood,
        emotion: analysis.emotion,
        factors: data.factors || [],
        isJournal: true,
        journalTitle: data.title || 'Untitled Journal',
        journalContent: data.content,
        sentiment: analysis.sentiment
      };
      
      // Save the journal record
      const savedEntry = await this.moodcheckService.saveMood(profileId, journalMoodData);
      
      return {
        success: true,
        id: savedEntry._id,
        analysis: {
          mood: analysis.mood,
          emotion: analysis.emotion,
          sentiment: analysis.sentiment
        }
      };
    } catch (error) {
      this.logger.error(`Error saving journal: ${error.message}`);
      this.logger.error(`Error stack: ${error.stack}`);
      throw error;
    }
  }
    
  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  async deleteMoodDocument(@Param('id') id: string, @Request() req) {
    const mood = await this.moodcheckService.getMoodById(id);
    // Ensure user can only delete their own mood entries
    if (mood.profileId.toString() !== req.user.profileId) {
      throw new Error('Unauthorized access to delete mood data');
    }
    await this.moodcheckService.deleteMood(id);
    return { success: true };
  }
  
  @Delete('entry/:entryIndex')
  @UseGuards(JwtAuthGuard)
  async deleteMoodEntry(
    @Param('entryIndex') entryIndex: string, 
    @Request() req
  ) {
    try {
      const profileId = req.user.profileId;
      if (!profileId) {
        throw new BadRequestException('Profile ID is required');
      }
      
      const index = parseInt(entryIndex, 10);
      if (isNaN(index) || index < 0) {
        throw new BadRequestException('Invalid entry index');
      }
      
      const updatedMood = await this.moodcheckService.deleteMoodEntry(profileId, index);
      return { success: true, entries: updatedMood.entries.length };
    } catch (error) {
      this.logger.error(`Error deleting mood entry: ${error.message}`);
      throw error;
    }
  }
}
