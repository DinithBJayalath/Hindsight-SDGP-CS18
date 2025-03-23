import { Controller, Get, Request } from '@nestjs/common';
import { DataDisplayService } from './data-display.service';

@Controller('data-display')
export class DataDisplayController {

    constructor(private readonly dataDisplayService: DataDisplayService) {}

    @Get()
  async findAll(@Request() req) {
    const emotions = await this.dataDisplayService.findAll(req.user.userId);
    return { 
      success: true, 
      count: emotions.length,
      emotions 
    };
  }
}
