import { Body, Controller,Get,Post} from '@nestjs/common';
import { MoodCheckDto } from './moodcheck.dto';

@Controller('moodcheck')
export class MoodcheckController {
    @Get()
    moodCheck(){
        return "Hello world";

    }
    @Post()
    saveMood(@Body() data:string){ // Using MoodCheckDto here causes an error
        console.log(data)
        return data;
    }


    
}
