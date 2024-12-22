import { Casts } from "./casts";

export class WeatherModel {
  status?: number; // 应该为 number
  count?: number; // 应该为 number
  info?: string;
  infocode?: number; // 应该为 number
  lives: Array<Casts> = [];
}
