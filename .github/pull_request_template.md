> [!IMPORTANT]
> 請大家詳閱下方Guidline，於每次上版之Pull Request 提供必要之上版資訊.

## Release Note (請簡要說明本次上版內容)

> _以下是Sample_

@Flora Chao

[User Story Release]

- User Story XXXXX1
- User Story XXXXX2

[Bug fix]

- Bug fix1
- Bug fix2


## 上版前Config 步驟 (於Deploy之前需要手動執行之步驟)

> _以下是Sample_

@Flora Chao

- 啟用Know Your Customer 功能
  1. Setup -> in the Quick Find box, enter General Settings, then under Financial Services Cloud, select General Settings.
  2. Enable Know Your Customer

- By profile給予apex class權限
  1. Setup > profile > 點進每個profile (直接點進profile，不用點edit)
  2. Enabled Apex Class Access > 新增以下項目：FinServ.ClientVisualizationController / FinServ.MoiAppConfigController

## 上版後Config 步驟 (於Deploy完成後需要手動執行之步驟)

> _以下是Sample_

- Flow Dummy User修改
  1. Account: Update AccountOwner When RM Changed
  2. Account: Update Occupy Related Field When ResRM Changed 兩支flow的 dummy user 要替換成CUB提供的user
