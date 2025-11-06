import http from '@ohos.net.http';
import { RouteResponse } from '../viewmodel/Route';
import CommonConstants from '../common/constants/CommonConstants';

export interface Location {
  longitude: number;
  latitude: number;
}

export class getRouteUtil {

  // 获取步行路径规划
  getWalkingRoute(start: Location, end: Location): Promise<RouteResponse | null> {
    return new Promise<RouteResponse | null>((resolve, reject) => {
      const origin = `${start.longitude},${start.latitude}`;
      const destination = `${end.longitude},${end.latitude}`;
      const url = `https://restapi.amap.com/v3/direction/walking?origin=${encodeURIComponent(origin)}&destination=${encodeURIComponent(destination)}&key=${CommonConstants.AMAP_API_KEY}&output=JSON`;
      console.log(url);
      console.log(origin);
      console.log(destination);


      // 创建HTTP请求
      let request = http.createHttp();
      let options = {
        method: http.RequestMethod.GET,
        header: { 'Content-Type': 'application/json' },
      } as http.HttpRequestOptions;

      let result = request.request(url, options);

      result.then((res) => {
        if (res.responseCode === 200) {

          const data: RouteResponse = JSON.parse(res.result.toString());
          if (data.status === "1" && data.route && data.route.paths && data.route.paths.length > 0) {
            resolve(data); // 返回路径规划数据
          } else {
            reject(new Error("No valid path found"));
          }
        } else {
          reject(new Error(`Request failed with status: ${res.responseCode}`));
        }
      }).catch(reject);
    });
  }
}

let getRouteUtilInstance = new getRouteUtil();
export default getRouteUtilInstance as getRouteUtil;
