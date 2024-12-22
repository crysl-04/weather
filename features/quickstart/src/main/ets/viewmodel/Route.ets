// 定义 Path 接口，描述路径的每一步
export class Step {
  instruction?: string;    // 步行指示
  road?: string;           // 道路名称
  distance?: string;       // 距离
  duration?: string;       // 预计时间
  polyline?: string;       // 路径坐标
  action?: string;         // 步骤动作
}

// 定义 Path 接口，描述一条路径
export class Path {
  distance?: string;       // 总距离
  duration?: string;       // 总时间
  steps: Step[] = [];      // 步骤列表
}

// 定义 Route 接口，描述路径规划信息
export interface Route {
  origin: string;          // 起点坐标 (经度, 纬度)
  destination: string;     // 终点坐标 (经度, 纬度)
  paths: Path[];           // 路径列表
}

// 定义 RouteResponse 类，描述返回的完整响应
export class RouteResponse {
  status?: string;         // 响应状态 (1为成功)
  info?: string;           // 请求状态的说明信息
  route?: Route;           // 路径信息
}
