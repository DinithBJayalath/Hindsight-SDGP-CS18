import { Body, Controller,Get,Post} from '@nestjs/common';
import { MoodCheckDto } from './moodcheck.dto';

@Controller('moodcheck')
export class MoodcheckController {
    @Get()
    moodCheck(){
        return "Hello world";

    }
    @Post()
    saveMood(@Body() data:MoodCheckDto){
        console.log(data)
        return data;
    }


    
}
