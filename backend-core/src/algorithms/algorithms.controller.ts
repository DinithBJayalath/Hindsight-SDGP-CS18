import {Controller, Get, Query} from "@nestjs/common";
import {analyze} from "./algorithms.client";

@Controller('algorithms')
export class AlgorithmsController {
    @Get('analyze')
    async analyze(@Query('query') query: string) {
        if (!query) {
            return {error: 'Query parameter is required'};
        }
        return {result: await analyze(query)};
    }
}