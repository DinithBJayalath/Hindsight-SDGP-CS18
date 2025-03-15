import { Controller,Get} from '@nestjs/common';

@Controller('moodcheck')
export class MoodcheckController {
    @Get()
    moodCheck(){
        return "Hello world";

    }
}
