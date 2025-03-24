export interface Activity {
  _id: string;
  title: string;
  description: string;
  icon: string;
  routeName: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}
