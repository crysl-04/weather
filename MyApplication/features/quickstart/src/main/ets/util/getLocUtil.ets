import http from '@ohos.net.http';
import {GeocodeResponse} from '../viewmodel/Geo'
import CommonConstants from '../common/constants/CommonConstants';

interface Location {
  longitude: number;
  latitude: number;
}


class getLocUtil {

  // 获取单个地址的经纬度
  getLoc(address: string): Promise<Location | null> {
    return new Promise<Location | null>((resolve, reject) => {

      const url = `https://restapi.amap.com/v3/geocode/geo?address=${encodeURIComponent(address)}&key=${CommonConstants.AMAP_API_KEY}&output=JSON`;

      // 创建HTTP请求
      let request = http.createHttp();
      let options = {
        method: http.RequestMethod.GET,
        header: { 'Content-Type': 'application/json' },
      } as http.HttpRequestOptions;

      let result = request.request(url, options);

      result.then((res) => {
        if (res.responseCode === 200) {
          const data: GeocodeResponse = JSON.parse(res.result.toString());
          if (data.status === "1" && data.geocodes && data.geocodes.length > 0) {
            const location = data.geocodes[0].location; // 获取经纬度字符串
            if (location) {
              // 使用传统的字符串拆分和赋值方式，避免解构赋值
              const locationParts = location.split(',');
              const longitude = parseFloat(locationParts[0]);
              const latitude = parseFloat(locationParts[1]);
              resolve({ longitude, latitude }); // 返回经纬度
            }
          } else {
            reject(new Error("No valid location found"));
          }
        } else {
          reject(new Error(`Request failed with status: ${res.responseCode}`));
        }
      }).catch(reject);
    });
  }

}


let getlocUtil = new getLocUtil()
export default getlocUtil as getLocUtil