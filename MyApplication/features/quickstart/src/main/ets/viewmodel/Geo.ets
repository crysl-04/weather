// Define the Neighborhood interface
interface Neighborhood {
  name?: string; // 邻里名称
  type?: string; // 邻里类型
}

// Define the Building interface
interface Building {
  name?: string; // 建筑物名称
  type?: string; // 建筑物类型
}

export class GeocodeResponse {
  status?: string; // 状态值，1表示成功，0表示失败
  info?: string;   // 返回状态描述
  infocode?: string; // 返回的状态码
  count?: number;   // 返回的结果数目
  geocodes: Geocode[] = []; // 地理编码信息列表
}

export class Geocode {
  formatted_address?: string; // 格式化的地址
  country?: string;  // 国家
  province?: string; // 省份
  citycode?: string; // 城市编码
  city?: string;     // 城市
  district?: string; // 区
  township?: string; // 镇
  neighborhood?: Neighborhood; // Use the previously defined interface
  building?: Building; // Use the previously defined interface
  adcode?: string;  // 区域编码
  location?: string; // 经纬度，格式为 "经度,纬度"
  level?: string;   // 匹配级别，例如：公交地铁站点
}