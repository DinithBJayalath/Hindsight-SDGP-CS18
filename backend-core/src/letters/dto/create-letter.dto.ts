export class CreateLetterDto {
  readonly title: string;
  readonly content: string;
  readonly userId: string;
  readonly deliveryDate?: Date;
}
