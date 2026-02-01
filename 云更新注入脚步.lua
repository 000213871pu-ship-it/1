测试云更新cdnlocal input = gg.prompt({"请输入卡密："}, {""}, {"text"})

if input == nil then
    os.exit()
end

local secret = input[1]

if secret == nil or secret == "" then
    gg.alert("卡密不能为空")
    os.exit()
end

secret = secret:match("^%s*(.-)%s*$")

gg.toast("验证中...")

local api_url = "https://360mixup.com/feature/pack/verify?api_version=1&app_id=4c0e9c716f7cdb200000242d50cf1ff7&app_version=2.3&device_code=7a72fbabd7c0b88a&lang=zh&platform=2&region=CN&secret=" .. secret .. "&version_code=23"

if not gg.makeRequest then
    gg.alert("❌ 不支持网络请求")
    os.exit()
end

local resp = gg.makeRequest(api_url)

if resp and resp.code == 200 then
    local json = resp.content
    
    local status = tonumber(json:match('"status":%s*(%d+)'))
    local msg = json:match('"msg":"([^"]+)"')
    
    if status == 1 then
        -- 验证成功
        local result_msg = "✅ 验证成功！\n\n"
        
        if msg then
            result_msg = result_msg .. msg .. "\n"
            
            -- 检查是否为永久卡密
            if msg:find("永久") then
                result_msg = result_msg .. "\n⏰ 有效期: 永久\n"
            -- 检查是否有具体到期时间
            elseif msg:find("有效期至") then
                local date_str = msg:match("有效期至：(.+)")
                if date_str then
                    local year, month, day = date_str:match("(%d+)-(%d+)-(%d+)")
                    if year and month and day then
                        local expire_time = os.time({
                            year = tonumber(year),
                            month = tonumber(month),
                            day = tonumber(day),
                            hour = 14,
                            min = 54,
                            sec = 38
                        })
                        
                        local current = os.time()
                        local remain = expire_time - current
                        
                        if remain > 0 then
                            local days = math.floor(remain / 86400)
                            result_msg = result_msg .. "\n⏰ 剩余时间: " .. days .. "天\n"
                        else
                            result_msg = result_msg .. "\n卡密即将到期！\n"
                        end
                    end
                end
            -- 检查是否有到期时间
            elseif msg:find("到期时间") then
                local date_str = msg:match("到期时间：(.+)")
                if date_str then
                    if date_str:find("永久") then
                        result_msg = result_msg .. "\n⏰ 有效期: 永久\n"
                    else
                        local year, month, day = date_str:match("(%d+)-(%d+)-(%d+)")
                        if year and month and day then
                            local expire_time = os.time({
                                year = tonumber(year),
                                month = tonumber(month),
                                day = tonumber(day),
                                hour = 0,
                                min = 0,
                                sec = 0
                            })
                            
                            local current = os.time()
                            local remain = expire_time - current
                            
                            if remain > 0 then
                                local days = math.floor(remain / 86400)
                                result_msg = result_msg .. "\n⏰ 剩余时间: " .. days .. "天\n"
                            else
                                result_msg = result_msg .. "\n卡密已过期！\n"
                            end
                        end
                    end
                end
            end
        end
        
        -- 验证成功后先显示卡密验证结果
        gg.alert(result_msg, "确定")
        
        -- 获取公告信息
        local notice_url = "https://360mixup.com/feature/config?api_version=1&app_id=4c0e9c716f7cdb200000242d50cf1ff7&app_version=2.3&device_code=7a72fbabd7c0b88a&lang=zh&platform=2&region=CN&version_code=23"
        local notice_resp = gg.makeRequest(notice_url)
        
        if notice_resp and notice_resp.code == 200 then
            local notice_json = notice_resp.content
            
            -- 解析公告信息 - 特别处理notice对象中的title和message
            local notice_match = notice_json:match('"notice":%s*({[^}]+})')
            if notice_match then
                local title = notice_match:match('"title":"([^"]+)"')
                local message = notice_match:match('"message":"([^"]+)"')
                
                -- 检查message是否为"//"，如果是则跳过
                if message and message == "//" then
                    message = nil
                end
                
                -- 显示公告
                local notice_msg = ""
                if title then
                    notice_msg = "📢 " .. title .. "\n\n"
                else
                    notice_msg = "📢 系统公告\n\n"
                end
                
                if message and message ~= "" then
                    notice_msg = notice_msg .. message .. "\n"
                else
                    notice_msg = notice_msg .. "暂无公告内容\n"
                end
                
                gg.alert(notice_msg, "确认")
            else
                -- 如果没有notice对象，尝试其他格式
                local title = notice_json:match('"title":"([^"]+)"')
                local message = notice_json:match('"message":"([^"]+)"')
                
                -- 检查message是否为"//"
                if message and message == "//" then
                    message = nil
                end
                
                local notice_msg = ""
                if title then
                    notice_msg = "📢 " .. title .. "\n\n"
                else
                    notice_msg = "📢 系统公告\n\n"
                end
                
                if message and message ~= "" then
                    notice_msg = notice_msg .. message .. "\n"
                else
                    notice_msg = notice_msg .. "暂无公告内容\n"
                end
                
                gg.alert(notice_msg, "确认")
            end
        else
            -- 公告获取失败，显示默认公告
            gg.alert("📢 系统公告\n\n公告获取失败，此版本已废用或网络不好，请自查！\n祝您生活愉快！", "确认")
        end 
        -- 在您现有代码的END后面添加以下内容

-- 显示欢迎进入马年脚本弹窗
gg.alert("🐎 欢迎进入马年脚本！", "确定")

-- 下面是您可以添加的功能代码
-- 例如：显示主菜单
local menu = gg.choice({
    "🎯 功能一：精准定位",
    "⚡ 功能二：极速模式",
    "🔒 功能三：安全防护",
    "📊 功能四：数据统计",
    "⚙️  功能五：设置",
    "🚪 退出脚本"
}, nil, "🐎 马年脚本 - 主菜单")

if menu then
    if menu == 1 then
        gg.alert("启动精准定位功能...", "确定")
        -- 这里添加功能一的代码
    elseif menu == 2 then
        gg.alert("启动极速模式...", "确定")
        -- 这里添加功能二的代码
    elseif menu == 3 then
        gg.alert("启动安全防护...", "确定")
        -- 这里添加功能三的代码
    elseif menu == 4 then
        gg.alert("显示数据统计...", "确定")
        -- 这里添加功能四的代码
    elseif menu == 5 then
        gg.alert("打开设置...", "确定")
        -- 这里添加设置功能代码
    elseif menu == 6 then
        gg.alert("感谢使用马年脚本！", "再见")
        os.exit()
    end
end

-- 或者添加简单的功能执行
local function mainFunction()
    gg.toast("马年脚本功能启动中...")
    
    -- 模拟一些功能
    for i = 1, 3 do
        gg.toast("正在执行第" .. i .. "项功能")
        os.sleep(1000)  -- 延迟1秒
    end
    
    gg.alert("🐎 马年脚本功能执行完成！", "确定")
end

-- 询问用户是否执行功能
local run_func = gg.alert("是否执行马年脚本功能？", "执行", "取消")
if run_func == 1 then
    mainFunction()
end

-- 脚本结束提示
gg.toast("马年脚本执行完毕")
print("脚本已安全退出")

-- 或者保持脚本运行，等待用户操作
while true do
    local action = gg.choice({
        "🔄 重新验证卡密",
        "📋 查看帮助",
        "ℹ️  关于脚本",
        "❌ 退出"
    }, nil, "🐎 马年脚本 - 操作菜单")
    
    if action == 1 then
        -- 重新验证（重新运行脚本）
        gg.alert("请重新运行脚本进行验证", "确定")
        os.exit()
    elseif action == 2 then
        gg.alert("📖 使用帮助\n\n1. 确保网络连接正常\n2. 输入正确的卡密\n3. 按照提示操作\n4. 如有问题请联系客服", "确定")
    elseif action == 3 then
        gg.alert("🐎 马年脚本 v1.0\n\n作者：马年脚本团队\n版本：2024.02.01\n功能：专业脚本工具", "确定")
    elseif action == 4 then
        gg.alert("感谢使用马年脚本！", "再见")
        os.exit()
    end
end
    else
        -- 验证失败
        local error_msg = "❌ 验证失败\n\n"
        if msg then
            error_msg = error_msg .. msg
        end
        gg.alert(error_msg, "确定")
    end
    
else
    gg.alert("❌ 网络请求失败", "确定")
end
