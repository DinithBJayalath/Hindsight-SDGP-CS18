import { Controller,Get,Post} from '@nestjs/common';

@Controller('moodcheck')
export class MoodcheckController {
    @Get()
    moodCheck(){
        return "Hello world";

    }
    @Post()
    saveMood(){
        return"post method";
    }


    
}
