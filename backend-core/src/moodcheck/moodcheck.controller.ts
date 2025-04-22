import { Body, Controller,Get,Post} from '@nestjs/common';
import { MoodCheckDto } from './moodcheck.dto';
import { plainToInstance } from 'class-transformer';
import { MoodcheckService } from './moodcheck.service';

@Controller('moodcheck')
export class MoodcheckController {
    constructor(private moodcheckService: MoodcheckService) {}
    @Get()
    moodCheck(){
        return "Hello world";

    }
    @Post()
    saveMood(@Body() body: { profileId: string; data: MoodCheckDto }) {
        const { profileId, data } = body;
        const moodCheckDto = plainToInstance(MoodCheckDto, data);
        this.moodcheckService.saveMood(profileId, moodCheckDto);
        return data; // Returning the data again for debugging perposes
    }



    
}
