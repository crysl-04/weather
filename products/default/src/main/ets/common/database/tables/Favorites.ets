// /*
//  * Copyright (c) 2023 Huawei Device Co., Ltd.
//  * Licensed under the Apache License,Version 2.0 (the "License");
//  * you may not use this file except in compliance with the License.
//  * You may obtain a copy of the License at
//  *
//  * http://www.apache.org/licenses/LICENSE-2.0
//  */
//
// import { relationalStore } from '@kit.ArkData';
// import CommonConstants from '../../constants/CommonConstants';
// import FavoritesData from '../../../viewmodel/FavoritesData';
//
// import Rdb from '../Rdb';
//
// export default class FavoritesTable {
//   private favoritesTable = new Rdb(CommonConstants.FAVORITES_TABLE.tableName, CommonConstants.FAVORITES_TABLE.sqlCreate,
//     CommonConstants.FAVORITES_TABLE.columns);
//
//   constructor(callback: Function = () => {}) {
//     this.favoritesTable.getRdbStore(callback);
//   }
//
//   getRdbStore(callback: Function = () => {}) {
//     this.favoritesTable.getRdbStore(callback);
//   }
//
//   insertData(userId: number, instrumentId: number, dateAdded: number, callback: Function) {
//     const valueBucket: relationalStore.ValuesBucket = {
//       userId: userId,
//       instrumentId: instrumentId,
//       date_added: dateAdded
//     };
//     this.favoritesTable.insertData(valueBucket, callback);
//   }
//
//   deleteData(favoriteId: number, callback: Function) {
//     let predicates = new relationalStore.RdbPredicates(CommonConstants.FAVORITES_TABLE.tableName);
//     predicates.equalTo('id', favoriteId);
//     this.favoritesTable.deleteData(predicates, callback);
//   }
//
//   query(callback: Function) {
//     let predicates = new relationalStore.RdbPredicates(CommonConstants.FAVORITES_TABLE.tableName);
//     this.favoritesTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
//       let count: number = resultSet.rowCount;
//       const result: FavoritesData[] = []; // 初始化结果数组
//
//       if (count > 0) {
//         resultSet.goToFirstRow();
//         for (let i = 0; i < count; i++) {
//           const tmp: FavoritesData = new FavoritesData(
//             resultSet.getDouble(resultSet.getColumnIndex('id')),
//             resultSet.getDouble(resultSet.getColumnIndex('userId')),
//             resultSet.getDouble(resultSet.getColumnIndex('instrumentId')),
//             resultSet.getDouble(resultSet.getColumnIndex('date_added'))
//           );
//           result.push(tmp); // 使用 push 方法添加元素
//           resultSet.goToNextRow();
//         }
//       }
//       callback(result); // 返回结果给回调
//     });
//   }
// }
