import { Test, TestingModule } from '@nestjs/testing';
import { DataDisplayService } from './data-display.service';

describe('DataDisplayService', () => {
  let service: DataDisplayService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [DataDisplayService],
    }).compile();

    service = module.get<DataDisplayService>(DataDisplayService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
