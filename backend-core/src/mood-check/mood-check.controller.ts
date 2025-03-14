import { Controller, Get } from '@nestjs/common';

@Controller('mood-check')
export class MoodCheckController {
    @Get('check')
    async check() {
        return { result: 'mood' };
    }
}
