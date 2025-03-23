import {Controller, Get, Post, Query, Body, Logger} from "@nestjs/common";
import {analyze, analyzeDetailed, getSentiment, analyzeJournalRecord} from "./algorithms.client";

@Controller('algorithms')
export class AlgorithmsController {
    @Get()
    great(): string {
        return 'Hello from algorithms';
    }
    
    @Get('analyze')
    async analyze(@Query('query') query: string) {
        if (!query) {
            return {error: 'Query parameter is required'};
        }
        
        
        try {
            // For backward compatibility, just return the emotion result
            const emotion = await analyze(query);
            return {result: emotion};
        } catch (error) {
            return {error: 'Analysis failed', message: error.message};
        }
    }
    
    @Get('analyze-detailed')
    async analyzeDetailed(@Query('query') query: string) {
        if (!query) {
            return {error: 'Query parameter is required'};
        }
        
        
        try {
            // Return detailed analysis with emotion and sentiment
            const analysis = await analyzeDetailed(query);
            
            
            return {
                result: analysis.emotion, // For backward compatibility
                emotion: analysis.emotion,
                sentiment: analysis.sentiment
            };
        } catch (error) {
            return {error: 'Detailed analysis failed', message: error.message};
        }
    }

    @Get('sentiment')
    async getSentiment(@Query('query') query: string) {
        if (!query) {
            return {error: 'Query parameter is required'};
        }
        
        
        try {
            // Get just the sentiment
            const sentiment = await getSentiment(query);
            return {sentiment};
        } catch (error) {
            return {error: 'Sentiment analysis failed', message: error.message};
        }
    }
    
    @Post('journal-record')
    async analyzeJournalRecord(@Body() data: { content: string }) {
        if (!data || !data.content) {
            return {error: 'Journal content is required'};
        }
        
        const content = data.content;
        
        try {
            // Analyze the journal content and return the full analysis
            const analysis = await analyzeJournalRecord(content);
            
            
            return {
                emotion: analysis.emotion,
                mood: analysis.mood,
                sentiment: analysis.sentiment
            };
        } catch (error) {
            return {error: 'Journal record analysis failed', message: error.message};
        }
    }
}