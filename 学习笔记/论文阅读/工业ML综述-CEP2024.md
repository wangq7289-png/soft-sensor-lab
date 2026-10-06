# 论文阅读笔记 · Machine learning for industrial sensing and control (CEP 2024)

> **本篇导读的信息来源与边界**
> 抓取对象：ar5iv 版全文 https://ar5iv.labs.arxiv.org/html/2401.13836 （对应 arXiv:2401.13836**v1**，2024-01-24，48 页），并核对 arXiv 摘要页与 arXiv HTML v1。
> **v1 是唯一版本**（arxiv.org/html/2401.13836v2 返回 404），期刊版为 *Control Engineering Practice* 2024，DOI 10.1016/j.conengprac.2024.105841。**期刊版的章节编号可能与本导读不同**，本导读按 arXiv v1 的实际编号写。
> 论文正文提到的 "supplementary material"（补充材料）**不在抓取到的 HTML 内**，本导读覆盖不到它，涉及处会明确标注。
> 表 2/3/4/5 的数字来自正文表格；图 2/3/4 的数字来自我读取论文原图所得（正文只给图号不给数字）。**除此以外没有编造任何章节名、数据集名或结果。**

## 这篇论文一句话讲了什么

这是一篇**"问题驱动"（problem-driven）而非"方法驱动"的综述**：作者把机器学习在化工/生物等流程工业（process industries）里的应用收拢成两块——**soft sensing（软测量）**和**process control（过程控制，含过程优化）**——然后用 2015–2023 年 534 篇文献的统计告诉你一个反直觉的结论：

**研究热点和工业落地严重错位。** 深学习/强化学习论文数量爆炸，但在软测量里真正进厂服役的只有 PLS、MLP、小波神经网络（WNN）、SVM、RVM、GPR、回归树这 7 类；DNN 有 87 篇、RNN 有 57 篇，**"industrial use" 一栏都是 0**。因此作者主张：不要迷信纯数据驱动，要走 **hybrid modeling（机理 + 数据）**和领域知识融合的路子。

## 为什么零基础也应该先读这篇

- **它几乎不写公式。** 作者明说这是 problem-driven survey，方法的数学细节外包给参考文献和补充材料。零基础不会被推导卡住，能先拿到"地图"。
- **它给了唯一的"落地排行榜"。** 绝大多数综述只罗列方法；这篇用 Table 5 把每个方法分成"仿真数据 / 工业数据 / 工业实际使用"三档，这是判断"我该学什么"的最硬依据。
- **第 3.4 节是工业界做软测量的完整七步流程**，从立项、成本收益、变量选择、数据预处理、离线验证、在线验证到交付班组。这是你在论文里很少见到的"工程 SOP"，和导师谈话时非常有说服力。
- **它直接对着你的方向说话。** 作者原话：soft sensing 是机器学习在流程工业里渗透最深的领域（"the most fundamental application"），而优化与控制不过是"在软测量内核上增加复杂度"。也就是说，**软测量是入口而不是边角料**。
- **它替你划掉了不该花时间的部分。** 例如作者明确说，对 ChatGPT / 大语言模型这类新东西的推测"超出本文范围"，也明确说 process monitoring（过程监控）要看别的综述。

## 论文骨架（逐节地图）

> 格式统一为：**这一节在讲什么 → 为什么有这一节 → 零基础该抓什么**。

### 摘要 + Keywords
**讲什么**：重新关注流程工业里用数据做大规模非线性 sensing 和 control；以 hybrid modeling 为方法论框架，覆盖 soft sensing / process optimization / control；指出共同痛点是纯数据驱动方法的**可解释性（interpretability）和效率（efficiency）**。
**为什么有**：这是全文的论点压缩包。
**抓什么**：记住三个关键词：hybrid modeling、soft sensing、interpretability。关键词栏还列了 statistical machine learning、deep learning、reinforcement learning、control。

### 1 Motivation（动机）
**讲什么**：ML 在工业里**不是新东西**——PCA、PLS、典型相关分析（CCA）、最大似然估计、预测误差法早就广泛使用；k-means、SVM、Fisher 判别分析也是；核方法、高斯过程、强化学习等非线性方法只在细分场景（niche）用过。新一波关注是被"提高自主性"（autonomy）驱动的：效率、一致性、安全、可扩展性、人员技能提升。
**为什么有**：先破除"ML 是新鲜事物"的错觉，也解释为什么这篇综述值得写。
**抓什么**：**"经典统计方法在工业界早已是主流，深度学习才是新来者"**——这个颠倒的直觉是全篇基调。作者引用的 Venkatasubramanian 2019 是了解工业 AI 三十年起落的好入口。

### 1.1 Overview and scope（范围界定）
**讲什么**：本文是 Gopaluni et al. 2020 的大幅扩展版；只讨论**在工业中用过、或在过程系统工程（PSE）里获得相当研究关注**的方法；明确**不讨论 ChatGPT / 大语言模型**的潜在应用。同时给出了全文最重要的定义三连：**AI ⊃ ML ⊃ {supervised learning, unsupervised learning}**。Table 1 是全篇缩写对照表，分三组：统计学习、机器学习与深度学习、强化学习与控制方法。
**为什么有**：一篇 48 页综述必须先说清"我不写什么"。
**抓什么**：**Table 1 建议打印出来放旁边**。你之后读任何一篇软测量论文，遇到的缩写基本都在里面（PLS、PCA、ICA、GMM、MLP、RBFNN、ELM、GRNN、WNN、RNN、ESN、ENN、DNNE、RT、RVM、GPR、BN、ANFIS、SVM、TL、MPC、RTO、PID，以及 RL 家族的 DQN、DDPG、TD3、SAC、PPO、A3C、ADP、HJB、PI²）。注意 RBC（reconstruction-based contribution）在全篇只出现在这张缩写表里，正文没展开——它属于过程监控，被作者排除在范围外了。

### 2 Mathematical modeling approaches（数学建模方法）— **重点章节**
这章是全文的**方法论地基**，后面所有应用都是它的特例。

**2.1 Knowledge-driven、data-driven 与 hybrid modeling**
**讲什么**：三种建模范式对立统一。
- **knowledge-driven（机理 / 白箱 white box）**：靠第一性原理（first principles），费力，但**能外推到训练条件之外**，参数有物理意义，属**参数模型（parametric）**。
- **data-driven（黑箱 black box）**：几乎不需要物理知识，部署和维护快，但**需要更多数据**，且**有效性不能超出训练条件太远**。又分参数模型和非参数模型（nonparametric，参数量随数据量增长，如最近邻插值、局部回归、GPR）；作者特意提醒这个区分并不干净——线性 SVM 是参数模型，而 RBF 核 SVM 因为"每个训练点一个权重"可算非参数。
- **hybrid（灰箱 gray box / block-oriented）**：结合两者。若数据部分是**非参数**的，叫 **hybrid semi-parametric modeling**。**multi-fidelity modeling** 是近亲：拿一个（可能不准的）机理模型当低精度，用（带噪的）过程数据去修正。

**为什么有**：这是全文的"概念框架"，作者自己说 hybrid modeling 是贯穿 soft sensing 和 control 的骨架。作者还提醒：hybrid modeling 在化工/生物过程工程里**已经被研究了 25 年以上**，宣称的好处包括更快预测、更好外推、更好标定、更易做模型全生命周期管理、性价比更高。
**抓什么**：**"外推能力"是理解全篇的钥匙**。工业现场永远会遇到训练数据里没有的工况，纯数据模型在这里天然吃亏——这一点会反复出现。Figure 1 给出混合模型的三种拓扑：**A 串行**（数据模型喂给机理模型）、**B 并行**（数据模型去修正机理模型预测）、**C 反串行**（机理模型喂给数据模型）。

**2.2 Hybrid modeling paradigms**
**2.2.1 传统串行与并行混合模型**（详细，值得读）
**讲什么**：
- **串行（serial）**：数据模型作为机理模型的输入。典型例子是物料平衡方程 + 用数据模型表达的动力学速率。**适合"机制不清楚但数据够"**。但作者警告：如果机理部分本身有**结构性不匹配（structural mismatch）**，串行方案不会比纯机理模型更好。
- **并行（parallel）**：数据模型修正机理模型的输出，最常见是**加性修正（additive correction）**，训练目标就是**残差（residual）**。能显著提升精度；但**工况大幅偏离训练集时，精度可能还不如纯机理模型**。
- 历史主流嵌入方法是 **MLP 和 RBF 回归**。此外还提到 subspace identification（子空间辨识）、PLS、GPR（因为能给出预测方差）。
- 两个共同难题：**如何自动确定数据部分的结构**（目标是不欠拟合也不过拟合），以及**参数辨识**。工具包括 AIC/BIC、LASSO/LARS 正则化回归、稀疏回归 + 混合整数规划、SINDy 稀疏辨识、**ALAMO 平台**（可对响应变量加约束以嵌入第一性原理）、半无限规划（semi-infinite programming）、**sum-of-squares 优化**。
**为什么有**：串行/并行是工业界真正在用的两种混合方式，作者要给可操作的分类。
**抓什么**：**"数据模型学残差"是混合建模最朴素也最实用的入口**。另一个金句：串行模型的困难在于数据部分的输出**往往无法直接观测**，只能把整个混合模型跑出来再和观测比——这对你的课题很关键（质量变量本来就测不到）。

**2.2.2 Emerging trends（新兴趋势）**（详细）
**讲什么**：传统混合建模以机理模型为核心；正在兴起的是**反过来的结构**（Figure 1C）：机理模型作为数据模型的输入。包括：
- **physics-informed neural networks（PINN）**：把守恒方程作为额外约束加在 MLP 参数上。
- **co-Kriging**：一个用机理模型数据训练的 GP，与一个用过程数据训练的 GP 结合。
- 用线性/非线性自回归技术做 **multi-fidelity**，以及 **deep Gaussian processes**。
- 另一个方向是 **feature engineering**：往输入里加机理模型里会出现的项（作者举的例子是**焓 enthalpy**——它不是测量量，但在能量平衡里有用的量）。
- 以及用 sum-of-squares 优化对多项式动态系统做带先验信息的回归。
**为什么有**：作者要说明这个领域在往哪走，且明确指出**没有通用框架**。
**抓什么**：**"选哪种混合结构"至今缺乏理论基础**（作者原话：selection process still lacks a solid theoretical basis）。这对你是机会也是坑：你如果做混合软测量，需要在论文里**用实验对比来说明你选的结构是对的**，而不是声称它理论上最优。作者最后还引 Venkatasubramanian 2019 提出更远的愿景（机理 + 数据 + 因果解释系统 / 领域知识引擎）。

### 3 Soft sensors in process industries（流程工业中的软测量）— **全文最重要的一章**
作者原话：soft sensing 是机器学习在流程工业里**最基础**的应用，优化与控制是"在软测量内核上加复杂度"，并且**软测量拥有机器学习应用中最高的工业渗透率**。

**3.1 Motivation for soft sensing**
**讲什么**：有些变量因技术限制或传感器昂贵而难以在线测量，但它们指示产品中间或最终质量，必须持续监控和控制。于是用**易测变量**建数学模型，**实时给出质量变量的连续估计**——这就是 soft sensor。作者点名主要用户行业：**炼油（refineries）、钢铁（steel plants）、聚合物（polymer）、水泥（cement）**。软测量同样分三类：knowledge-driven（白箱，如 **Kalman filter**）、data-driven（黑箱，基于历史过程数据）、**hybrid（灰箱，用数据方法估计机理模型的参数）**。
**为什么有**：给全章下定义、分类。
**抓什么**：**注意灰箱在软测量里被定义成"用数据方法估计机理模型的参数"**，这和 2.2 的串行/并行不完全等同，是很实用的第三种理解方式。Figure 2（我读了原图）给出软测量应用的学科分布：**化学工程 72.12%、生物过程工程 13.78%、机械工程 3.53%、其他 10.58%**——也就是说，**这个领域基本上就是化工的领域**。

**3.2 A quantitative overview of soft sensing（定量概览）— 全篇最该反复读的一节**
**讲什么**：作者做了一次文献计量。检索范围：**2015–2023 年**、Elsevier/Springer/Wiley/Taylor and Francis/MDPI/World Scientific/Hindawi/De Gruyter/AMSE/IEEE 等出版社的相关期刊；关键词：**"soft sensor"、"virtual sensor"、"inferential model"**。
Figure 3（读原图）：逐年发文量从 2015 年约 40 篇升到 2022–2023 年约 100–105 篇；三类方法占比 **data-driven 91.8%、knowledge-driven 6.5%、hybrid 1.7%**。
主要结论（这些都是论文的原话）：
- 研究**从统计方法大幅转向机器学习方法**。
- **ANN 获得最多关注**。
- **浅层单隐层前馈网络**（涵盖 MLP、GRNN、ELM、RBFNN、WNN）作为一个类，**比 RNN 和深度学习用得更多**。
- 除 ANN 外，**SVM 是第二广泛使用的机器学习方法**。
- **hybrid 混合模型软测量获得的研究关注最少**（对应 Figure 3 的 1.7%）。
- **TL（transfer learning，迁移学习）**正在缓慢进入 inferential measurement；"迁移学习尚未被用于过程变量的在线预测"（作者原话）。TL 的含义：把在一个任务上学到的知识用到另一个相关任务上，**在目标任务数据难收集时特别有用**。
- **静态（time-invariant）软测量**只用单一操作模式的数据建模，**随过程漂移到新操作区，精度会随时间退化**。**自适应（adaptive）软测量**通过用新样本更新参数解决这个问题。**"不到三分之一的软测量是自适应的"**，其中**大多数用 just-in-time 策略**实时更新参数。Figure 4（读原图）：**全局软测量 83.21%，自适应 16.79%**。
- 因此**需要计算上可行的方法**；**PLS 是局部建模（local modeling）的首选算法**。
- 全局软测量的训练在**离线**做，训练好后**在线**部署得到实时估计；训练时间相对很长，但大多数全局软测量在线估计很快。

**Table 2（统计 vs ML 方法的占比）**：统计方法合计 22.73%，ML 合计 77.27%。逐项：PLS 11.38、PCA 4.54、GMM 2.64、ICA 1.70、LASSO 1.51、FA 0.95；ANN 47.72、SVM 7.53、GPR 5.87、RT 4.59、SFA 2.75、RVM 2.57、BN 2.57、TL 2.02、ANFIS 1.65。

**Table 3（ANN 内部构成）**：DNN 34.64、RNN 21.94、MLP 14.23、ELM 11.92、GRNN 6.92、ESN 4.23、RBFNN 2.68、WNN 2.31、DNNE 0.75、ENN 0.38。
> **注意一个容易误读的地方**：单看单项，DNN（34.64%）是最大类别；但正文说的是**把浅层网络当作一个类**（MLP+GRNN+ELM+RBFNN+WNN ≈ 38.1%）时，它才超过 RNN 和 DNN。两个说法不矛盾，但引用时要说清是"单项"还是"类合计"。

**Table 4（自适应软测量中局部建模的方法占比）**：PLS 31.78、GPR 15.30、SVR 11.77、ELM 9.42、LASSO 8.24、PCA 7.05、BN 4.70、MLP 3.52、FA 3.52、GMM 2.35、RVM 2.35。

**Table 5（工业落地程度）— 本综述最有价值的一张表**
把每个方法分成"仿真数据 / 工业数据 / 工业实际使用"三档。合计 **534 篇**（仿真 107、工业数据 414、工业实际使用 **13**）。
**有工业实际使用记录的只有 7 类方法：PLS（3 篇）、SVM（4 篇）、GPR（2 篇）、MLP（1 篇）、WNN（1 篇）、RVM（1 篇）、RT（1 篇）。**
反例极有冲击力：**DNN 共 87 篇（工业数据 80 篇），工业使用 0；RNN 共 57 篇（工业数据 53 篇），工业使用 0；PCA 24 篇、GMM 14 篇、ELM 31 篇、ANFIS 9 篇、BN 14 篇、TL 11 篇、ESN 11 篇，工业使用全是 0。**
作者自己也提醒：**可能存在发表偏倚（publication bias）**——不是所有真实工业应用都会被发表。
**为什么有**：这是全文的实证核心，用来支撑"研究热度 ≠ 工业落地"这个论点。
**抓什么**：把 Table 2（谁研究得多）、Table 5（谁真的用了）和 Table 8（谁被强调）三张表对照着看，**这三张表的落差就是这篇综述的论点本身，也是你选题的坐标系**。

**3.3 Computational cost of soft sensors（计算成本）**
**讲什么**：区分两个时间：**training time（训练时间，确定模型参数）**和 **soft sensing time（得到在线估计的时间）**。软测量部署在 DCS（distributed control system，分布式控制系统）里，按固定采样间隔出估计。
- **PCA、SFA、ICA、FA 可以单次迭代算出**，计算时间相对低；**LASSO、GMM 需要用迭代优化**。总体上 ML 方法比统计方法更耗时。
- 影响 ML 计算复杂度的因素（作者列的清单）：**训练数据量、特征/输入变量个数、训练算法类型、层数、每层神经元数（规模）、设备类型（CPU 或 GPU）**。
- 速度排序（作者做的实测 + 文献判断）：**ELM 最快**（没有需要学习的参数），**GRNN 第二快**（只有 1 个可学习参数）；然后是回归树和 DNNE；RBFNN 因为用"混合学习"（中间层无监督 + 最后一层线性回归）通常比用迭代梯度下降的 MLP、ANFIS、WNN 快；**SVM 是核方法里最慢的**；贝叶斯网络用 EM（expectation-maximization）算法所以比回归树略慢；**RNN 等动态方法比静态方法需要更多内存和算力**；**DNN 是公认最贵的方法**，需要大量训练数据。
> 脚注 4 值得注意：作者用**工业数据**建了各种软测量，在**独立验证集**上测试并记录计算时间，得出 ELM 最快、GRNN 第二——**这是作者自己的实验结果，不是引用的**。
**抓什么**：**软测量的第一约束往往不是精度而是"能不能在线跑得动"**。想把模型塞进 DCS，复杂模型会先死在工程上。

**3.4 Industry implementation of soft sensors（工业实施）— 全篇最实用的一节**
**讲什么**：谁在做软测量？**厂内控制工程师**，或 **Honeywell、Yokogawa 这类服务商的第三方工程师**（用服务商自己的软件）。当现有技术不够用、或厂内工程师不懂其他算法时，**企业会资助高校、研究机构或创业公司**开发复杂非线性软测量——**这就是你所在的位置**。
**七步流程（原文顺序）**：
1. 立项：组建含**班组操作员（panel operator）、工艺工程师、控制工程师、项目经理**的团队；由工艺工程师写**项目章程（charter）**定义目标、范围、职责、时间线；核心是**量化收益（通常折算成省多少钱）**，即成本收益分析：一次性成本（硬件、软件、顾问）+ 持续成本（软件许可、厂内专家支持维护）对比预期收入/产量提升与成本下降。团队满意才启动。
2. **获取工艺知识或专家经验来挑选输入变量**。好处是避免引入冗余输入变量，降低模型复杂度、提升精度。**如果没有这类知识**，可用 LASSO、hybrid LASSO、ridge regression 来筛掉影响可忽略的输入变量。
3. **数据收集与预处理**：过程数据"**量大但信息量低**"（abundant but poor in information），因为有显著扰动、异常值和缺失值。**通常做法是检测并直接删除异常样本**（作者承认这"理论上不严谨"），缺失值同样处理。
4. **多速率采样（multi-rate sampling）**：输入采样频率高于输出时，需要同步变量；用**降采样（down-sampling）**——删掉那些没有对应输出测量的输入样本。
5. **划分训练集与验证集**，做**离线验证（offline validation）**。**通常做法是先建一个线性模型，如果线性模型精度不够，才上更复杂的统计或机器学习算法。**
6. **在线验证（online validation）**：部署到 DCS，监控一段时间，性能不好就改。指标是**相关系数（correlation coefficient）和均方根误差（RMSE）**；**另加定性分析：看软测量估计是否跟随实验室化验数据的趋势**。如果估计差，**先查输入数据**（传感器故障、数据传输问题、异常值、停车、装置波动）；如果输入数据没问题，可选策略是：用最新数据重训、换建模算法、换训练算法、改参数初始化方法、采用能避免或减少过拟合的方法。
7. 在线长期稳定后，**软测量被当作测量仪表进入控制回路**。成功实施后**移交给班组操作员**。作者强调：**这个"人在回路（human-in-the-loop）"环节是把研究成果转成实际应用的关键**。
**为什么有**：作者要弥合"工业界与学术界的脱节"（industrial-academic disconnect），这节就是给学术界看的工程现实。
**抓什么**：**第 5 步"先试线性模型"和第 6 步"先查数据再怪模型"是极强的工程判断力信号**，非常适合在导师谈话里说出来。第 2 步说明**变量选择要靠工艺知识**，这正好是纯 ML 背景的人最容易忽略的地方。

**3.5 Challenges in soft sensor development（软测量开发挑战）** — 三条
1. **缺乏标注数据（lack of labeled data）是首要挑战。** 质量变量测量频率远低于温度、压力、流量、液位：**质量变量每班（8 小时）或每 24 小时才采一个样**。长期采样间隔导致可用的**有标签数据严重不足**，模型可能学不到输入输出关系。对策：**virtual sample generation（虚拟样本生成）**；或用**半监督学习（semi-supervised learning）**——用 PCA、autoencoder、stacked autoencoder、deep belief network 这类无监督算法从**无标签输入数据**中提特征，再用任一线性的或非线性的数据驱动模型把这些特征与输出关联。
2. **工况变化（operating condition changes）**：随产品需求、原料价格等变化，用某一工况数据建的软测量在工况改变后表现会变差。对策：**multimode soft sensor（多模态软测量）**。
3. **软测量维护（maintenance）**：在线软测量性能会随时间退化，估计不再跟随化验趋势。对策：**用近期数据重训并重新上线**；更流行的做法是 **bias updating（偏差更新）**，把软测量输出拉近实验室化验数据。
**抓什么**：这三条几乎就是你开题报告里"研究意义"的现成模板：**小样本 + 工况漂移 + 长期维护**。注意作者**没有使用 "concept drift" 这个词**（我全文检索确认），他用的是 "performance degrades over time" 和 "operating condition changes"；你在写作时如果要用 concept drift，需要自己说明这是文献里的通行叫法。

### 4 Data-driven and hybrid modeling approaches for optimization and control — **次重点**
**讲什么**：同样把问题放到优化和控制的语境里重讲一遍数据驱动与混合建模，并引入强化学习（RL）作为新范式。作者的观点：**hybrid modeling 是知识驱动与数据驱动之间的一个谱（spectrum）；model-based optimization、MPC、RL 也都在"有模型"和"无模型"之间成谱**。这些技术与混合建模天然兼容。

**4.1 Model-based optimization（基于模型的优化）** — 一两句带过即可
**讲什么**：大量混合建模应用是**离线过程优化**。吸引力在于：把关键操作变量放在机理部分以**保留外推能力**，其余部分用数据方法以**降低计算负担**。传统上用局部（梯度）或随机搜索，近期趋势是**用完全搜索（complete search）技术以避免陷入局部最优、保证全局最优**，因为问题里嵌了 ML 模型（MLP、高斯过程、gradient-boosted trees）。化工应用包括反应器操作与流程优化、**最优催化剂选择**。当数据/混合模型用来加速一个更基础模型的优化时，这就是 **surrogate-based optimization（代理模型优化）**，分：
- **全局方法**：先用一组机理仿真构造代理模型再优化，常在迭代中逐步精化。用 MLP、GP 或基函数组合。应用于**精馏塔严格设计**、**流程/超结构优化**。
- **局部方法**：在**信赖域（trust region）**内维持精确代理，位置和尺寸迭代调整，代理随信赖域移动而重建；在代理满足 full linearity 性质时可给出全局收敛保证。应用于 CO₂ 捕集与碳捕集转化。
**抓什么**：只需记住"**代理模型 + 信赖域**"这两个词，它和你后面可能用到的贝叶斯优化是同一个思想家族。

**4.2 Model predictive control and real-time optimization（MPC 与 RTO）** — 一两句带过
**讲什么**：RTO 与非线性/经济 MPC 都以过程模型为核心；**至今最成功的实施都靠机理模型**。数据驱动方向用历史数据或机理仿真训练的代理模型（MLP、GP）来驱动优化，但**把混合模型嵌入 MPC 的工作相对很少**。提到 Teixeira et al. 2006（批间优化 + 混合模型表示细胞群子系统）、Cubillos et al. 2007（Williams benchmark plant 上嵌入 MLP 的并行混合模型，但不得不用随机搜索求解）、Zhang et al. 2019b（同一个混合模型同时用于 RTO 和 MPC 两层，在仿真的 CSTR 和精馏塔上验证）。作者结论：**这类技术缺乏工业或实验层面的实现**。
另一个关键是 **modifier adaptation（修正项自适应）**：**不修改机理模型，而是给优化模型里的代价函数和约束函数加上修正项（modifiers）**。发展脉络：最初的线性（梯度）修正 → Gao et al. 2016 的二次回归修正（含曲率信息、滤噪）→ Singhal et al. 2016 的二次代理 + 仿信赖域在线自适应（工业应用：**燃气压缩机负荷分配、固体氧化物燃料电池**）→ Ferreira et al. 2018 **首次用高斯过程做代价与约束的修正项**（因为 plant-model mismatch 通常是**结构性**的）→ del Rio Chanona et al. 2019/2021 引入信赖域 → Petsagkourakis et al. 2021 用 **co-Kriging**（低精度 GP 模拟机理模型，嵌入用过程测量训练的高精度 GP）。GP 的好处是能做**实时不确定性量化**，从而以高置信度满足**机会约束（chance constraints）**。作者提醒：**这些 RTO 技术的潜在收益大多只在数值仿真里研究过，不能替代实验和工业验证**。
**抓什么**：如果你以后不碰控制，这节可以只留一句话——**"工业界主流仍是机理模型，数据驱动控制缺工业验证"**。

**4.3 Reinforcement learning（强化学习）**
**4.3.1 RL 用于过程控制**（可略读）
**讲什么**：RL 是解决**数据驱动序贯决策**问题的一类数值方法，目标是找最优策略（控制器）。需要解 **Bellman 方程**（基于最优性原理），但往往因为变成高维优化而不可解；深度神经网络提供了近似求解的高效数值方法，于是有了 **deep reinforcement learning**。作者列出 RL 相对数学规划方法的三个优势（引 Shin et al. 2019、Nian et al. 2020、Spielberg et al. 2019、Yoo et al. 2021a）：
1. 对一般随机控制问题能得到**闭环状态反馈策略**，而数学规划方法得到的是**开环解**；大部分计算在离线完成，若离线环境和在线一致，策略就是最优的。
2. 随机控制问题的数学规划形式往往**大到无法在一个决策间隔内求解**；RL 通过值函数/策略函数**隐式或显式地量化不确定性**，训练好的策略**在线计算量极小**。
3. RL 对系统知识水平**灵活**：无模型、部分无模型、有模型都能做。
**Table 6** 是 RL 与数学规划方法的对比（维度：模型知识、反馈、在线计算、离线计算、鲁棒性、约束处理、渐近稳定性、可扩展性、适应性）。关键差异：**在线计算 RL 可忽略、数学规划很高**；**约束处理 RL "不成熟（尤其状态变量约束）"、数学规划 "直接了当"**；**稳定性 RL 是"最终有界"、数学规划是"渐近稳定"**；**适应性 RL "可控制探索但慢"，数学规划"快但依赖估计器"**。
历史工作包括 Q-learning 用于**补料分批生物反应器（fed-batch bioreactor）**的跟踪控制与自由末端最大化；用线性近似器解连续状态空间；Zhu et al. 2020 用 "factorial fast-food dynamic policy programming"（无模型 RL 变体）做**醋酸乙烯酯单体（Vinyl Acetate monomer）过程**，通过动作空间因子分解提升可扩展性。**Table 7** 列出无模型深度 RL 在过程控制的应用（DQN/PPO/DDPG/TD3/SAC/A3C/REINFORCE/GVF，应用含四罐系统、HVAC、聚合过程、移动床过程、补料分批生物反应器、设定值跟踪、酯交换过程、PID 整定、多元醇过程、水处理）。
**抓什么**：只需要知道**"RL 在线算得快，但约束和稳定性保证弱"**。

**4.3.2 RL 的实际实现**（可略读）
**讲什么**：一个有前途的方向是**用 RL 综合/整定已有的控制结构**，而不是替换它。典型是 **PID 整定**：PID 是最底层控制，且有大量整定方法和工业自整定器可以作基准；用 RL 增强 PID 能立刻见效，且**不替换基础层**。相关工作：模型无关 RL 调度一组先验 PID 增益或用内模控制得到的增益；Berger and da Fonseca Neto 2013 用有模型 RL（dual heuristic dynamic programming）算 PID 增益；Nian et al. 2020 用 DQN 定 PID 增益并与 MPC 比较；Lawrence et al. 2022 用 **TD3** 做 PID 自整定的**实验研究**。另一个方向是**分层控制结构**（Shafi et al. 2020 的沥青回收率两层结构；Kim et al. 2021 的补料分批生物反应器两层结构：上层有模型 RL 做优化，下层 MPC 跟踪轨迹并抑制实时扰动）。
对比不同 RL 方法的实践评价标准：Wang et al. 2019 用名义性能、**样本效率（sample efficiency，含总训练时间、每步训练时间）**、抗噪鲁棒性、渐近性能比较 14 种算法；Lawrence et al. 2022 提出名义性能、稳定性、系统扰动、初始化、超参数、训练时长、实用性、专用性；Dogru et al. 2021 用**探索程度**（访问过的状态动作空间占总空间比例）。
**关键判断（作者原话）**：**在物理系统上的 RL 实现是稀少的**，且多集中在 **PID 整定或低维状态/动作空间**，**级联水箱系统（cascaded tank system）是最常见的环境**。原因：额外工程与软件开发成本、算法复杂度、样本效率/收敛/闭环稳定性等实践与理论问题；大多数深度 RL 算法虽然最终性能好，但代价是**大量超参数调优和实现间巨大差异**。
**抓什么**：**"RL 在工业里基本还停留在水箱和 PID 整定"**——这是对 RL 炒作最有力的降温。

**4.3.3 深度 RL 的挑战与进展**（可略读）
**讲什么**：聚焦 **sample efficiency（样本效率 = 训练一个 RL agent 需要多少数据）**。经典值方法（Q-learning）和策略方法（REINFORCE）有理论收敛保证，但收敛慢（值估计高方差）、或只适用于表格/线性函数近似。DQN 是第一个重要扩展，但**只能处理离散动作空间**。DDPG 支持连续动作空间，但**出了名的难用**（对超参数敏感、Q 值高估），限制了它在过程控制里的可行性（**物理系统不能被大规模试探**）。TD3 和 SAC 在 DDPG 基础上改善了训练鲁棒性和样本效率。**但作者给出关键结论：仅靠无模型 RL 算法还不够数据高效，在真实工业应用中尚不可用。**
进展方向：
- **有模型 RL**：需要与工厂的交互少得多。通过解 **Hamilton-Jacobi-Bellman 方程**的连续时间版本，即 **approximate dynamic programming（ADP）**；变体有 heuristic dynamic programming、dual heuristic programming、globalized dual heuristic programming；**PI²（policy improvement with path integrals）**是求解随机 HJB 的采样方法，在机器人学习上数据效率突出。
- **统一无模型与有模型**：无模型渐近性能更好但样本复杂度差；Bao et al. 2021 用动力学模型改进 critic 的动作梯度估计。
- **离线强化学习（offline RL，又称 batch RL）**：仅从历史数据学最优策略；虽然 DDPG 这类 off-policy 算法理论上能从历史数据学，但**除非对策略加约束，在线探索仍是关键**。Mowbray et al. 2021 提出**先用历史过程数据预训练、再在线微调**。
- **迁移学习**：预训练策略（如仿真环境里）作为真实系统的初始策略；在批式生物过程优化上有演示；在真实系统上微调初始策略可有效缓解 plant-model mismatch。
- **元学习（meta-learning，"learning to learn"）**：用先前训练经验快速学新任务。**meta-reinforcement learning** 训练一个"元 agent"，从多个相关系统综合经验以快速适应新系统。Finn et al. 2017（直接优化初始参数，少量数据即可快速适应新任务，优于标准迁移学习）、Duan et al. 2016（把隐含上下文变量学进元策略架构，捕捉"任务"结构）。作者认为这个框架在过程控制里有吸引力，因为**很多系统有已知结构，可以在一组相关系统上训练**；它的好处是**在线实施时省掉了模型辨识步骤**。已有过程控制应用。
**结尾判断**：这些算法虽然进步很大，**但还不实用（not yet practical）**。
**抓什么**：把"**离线 RL + 迁移学习 + 元学习**"记成一组词——它们都是为了绕开"真实装置不能乱试"这个死结。这和你软测量里"标签少、不敢扰动装置"的困境是同一个问题的两种表述。

### 5 Discussion（讨论）
**讲什么**：**Table 8** 给出四种方法族 × 两个应用领域（soft sensing / process control）的强调程度矩阵：
- **statistical learning**：soft sensing ✓ / process control ✗
- **machine learning**：soft sensing ✓ / process control ✓
- **deep learning**：soft sensing ✓ / process control ✓
- **reinforcement learning**：soft sensing ✗ / process control ✓
作者指出一个张力：**Table 2 显示软测量文献对深度学习兴趣显著，但 Table 5 显示 PLS 和 SVM 才是工业用得最多的**。过程控制那边则更强调深度学习和 RL，且**仿真研究很普遍**。
进一步论点：**要让现代 ML 真正发挥价值，需要一个涵盖建模、感知、控制的统一框架。RL 很适合用全局的回报目标来桥接 sensing 和 control**（而不是把预测性能和控制性能当成两个独立目标）。作者举了两个例子说明 RL 也能用于感知：Xie et al. 2023 用 RL 做 sensing；Esfahani et al. 2023 用 RL 在**同一个闭环性能目标下**同时做状态估计和控制。
另一面：深度学习和 RL **充满复杂度与超参数，很难看清其根本机理**。有希望的路线是**蒸馏 RL 流程、并重拾机器学习的其他分支**；真正稳健强大的方法会来自**经典统计学习（Table 1）与深度学习/RL 新概念的批判性融合**。Eysenbach et al. 2022 用二元分类 + 策略迭代达到 state-of-the-art 就是一个例子。
**5.1 Conclusions**：近年来 ML 的进展让流程工业实现更高自动化水平重新有了乐观理由；本文用实践视角审视了软测量和过程控制。**软测量是统计与机器学习技术在工业应用中最主导的领域**；**深度学习获得了大量研究关注，但工业成功有限**。通过综合研究趋势与工业需求，希望帮助学术界和工业界开发出既有先进性又可实践的方法与控制器。
**抓什么**：**Table 8 + "研究热度 ≠ 工业落地"就是全文结论**。还有一句可以背下来在谈话中用：**深度学习关注多但工业成功有限（limited industrial successes）**。

### Acknowledgements / References
**讲什么**：致谢提到 NSERC、Honeywell Process Solutions、EPSRC 等资助。参考文献约 170 条。
**抓什么**：从致谢可以看出作者群与 **Honeywell（工业界）**有合作，这解释了为什么这篇文章的"工业现实感"比一般综述强。作者名单里的 **Biao Huang** 和 **R. Bhushan Gopaluni** 是软测量/过程辨识方向的知名学者，可作为你后续追踪的线索。

## 5 个必须带走的核心观点

### 观点 1 · 软测量是 ML 在流程工业渗透最深的场景，但它至今仍是"传统方法的天下"
- **论文依据**：作者原话——soft sensing 是机器学习在流程工业里最基础的应用，优化与控制只是"在软测量内核上加复杂度"，软测量拥有"最高的工业渗透率"。Table 5 的 534 篇文献里，标注工业实际使用的只有 **13 篇**，且只涉及 **PLS、SVM、GPR、MLP、WNN、RVM、RT** 这 7 类方法；**DNN（87 篇）和 RNN（57 篇）的工业使用数都是 0**。Table 2 也显示 ANN 占 47.72%、PLS 占 11.38%、SVM 占 7.53%。
- **对软测量课题的意义**：这既是机会也是警告。**机会**：软测量被作者定位成整个工业 ML 的入口，选题正当性极强。**警告**：如果你一上来就用 LSTM/Transformer，你需要准备好回答"为什么前人在 57 篇 RNN 软测量论文里都没能进厂，你能吗"。更稳的策略是**把 PLS/GPR/SVM 作为必须打赢的 baseline**，把深度模型当作"有条件才用"的增量。

### 观点 2 · 浅层网络和核方法在软测量里比深度网络更"划算"，计算成本是硬约束
- **论文依据**：正文明确说浅层单隐层前馈网络（MLP、GRNN、ELM、RBFNN、WNN）作为一类，应用多于 RNN 和深度学习。Table 3 的构成是 DNN 34.64%、RNN 21.94%、MLP 14.23%、ELM 11.92%、GRNN 6.92%、ESN 4.23%、RBFNN 2.68%、WNN 2.31%。3.3 节给出速度排序：**ELM 最快**（无参数需学习）、**GRNN 第二**（只 1 个可学习参数）、然后是回归树和 DNNE，**SVM 是核方法里最慢的**，**DNN 是最贵的**且需要大量训练数据。作者还用**工业数据**自己做了实验，在独立验证集上测时间，结论同样是 ELM 最快、GRNN 第二。
- **对软测量课题的意义**：软测量要跑在 DCS 里、按采样间隔出值，**"能不能在线跑得动"往往先于"精度高不高"成为约束**。所以你的实验表格里除了 RMSE，应该主动加一列**训练时间和估计时间**——这正是这篇综述示范的评价维度，也是审稿人会欣赏工程意识的地方。

### 观点 3 · 静态软测量会随时间退化，但自适应软测量不到三分之一，且以 just-in-time 为主
- **论文依据**：静态（time-invariant）软测量只用单一操作模式的数据，**随过程漂移到新操作区，精度会随时间下降**；自适应软测量通过新样本更新参数来解决。**"不到三分之一的软测量是自适应的"**，其中大多数用 **just-in-time 策略**实时更新参数。Figure 4（读原图）：**全局软测量 83.21%，自适应 16.79%**。因为要在线更新，**方法必须计算上可行**；**PLS 是局部建模的首选算法**（Table 4：PLS 31.78%、GPR 15.30%、SVR 11.77%、ELM 9.42%）。3.5 节把"工况变化"和"软测量维护"列为三大挑战中的两个，维护的主流做法是**重训**和 **bias updating**。
- **对软测量课题的意义**：这是**最容易做出增量贡献的缺口**——83% 是静态的，而静态的注定会退化。可行的切入点是：**在 PLS/GPR 这类轻量模型上做自适应或 just-in-time**（而不是在深度模型上做自适应），因为局部建模的算力上限被 Table 4 的分布直接反映出来了。另外注意，**论文没有用 "concept drift" 这个词**，用的是 "performance degrades over time" 和 "operating condition changes"；你写论文时可以建立这个术语对应关系，但要自己交代。

### 观点 4 · 首要挑战是"没有标签"，因为质量变量每 8 小时甚至 24 小时才测一次
- **论文依据**：3.5 节第一条："**缺乏标注数据是建立好的软测量模型必须处理的主要挑战**"。质量变量的测量频率远低于温度、压力、流量、液位：**一个质量变量样本每班（8 小时）或每 24 小时才采一次**。作者给的两条对策是 **virtual sample generation（虚拟样本生成）**和**半监督学习**——用 PCA、autoencoder、stacked autoencoder、deep belief network 从**无标签输入数据**里提特征，再把特征接到一个线性的或非线性的数据驱动模型上。此外 3.4 节第 4 步指出工业数据普遍是**多速率采样**，需要用**降采样**同步：**删掉那些没有对应输出测量的输入样本**（这意味着"数据清洗"本身就在进一步减少本已稀少的标签）。
- **对软测量课题的意义**：**"标签稀缺 + 多速率 + 强扰动"是工业数据的三件套**，而不是可以绕过的困难。你的研究问题最好明确地落在"用少量标签 + 大量无标签过程变量"这个设定上。同时注意：**降采样会扔掉数据**，这本身可能就是一个可改进点（例如用软对齐或生成式方法替代粗暴删除）。

### 观点 5 · 纯数据驱动受限于可解释性与外推能力，出路是 hybrid modeling 和领域知识融合
- **论文依据**：摘要明确指出共同挑战是"纯数据驱动方法的**可解释性和效率**"，结论是需要谨慎平衡深度学习与领域知识。2.2.1 节给出机理性的理由：**数据驱动模型的有效性不会超出训练条件太远**，而**机理模型因为蕴含第一性原理可以外推**；并行混合模型（数据模型学残差）能显著改善机理模型精度，但**当工况与训练集差别很大时，精度可能还不如纯机理模型**。2.1 节还提到 **hybrid modeling 在化工/生物过程工程里已被研究超过 25 年**，宣称的好处包括外推能力、标定性质、模型全生命周期管理和性价比。反过来，Table 8 显示 **RL 在 soft sensing 一栏是 ✗（几乎不涉及）**，而 4.3.3 节结论是**无模型 RL 尚不够数据高效、在真实工业应用中还不可用**，且 4.3.2 节指出**物理系统上的 RL 实现稀少**、多集中在 PID 整定和低维空间、级联水箱是最常见环境。
- **对软测量课题的意义**：如果你手上有一点机理知识（哪怕只是物料/能量平衡、或明确的单调性/量程约束），**把它变成"先验"而不是"背景介绍"**，是这篇综述反复指出的高价值方向。落地上最可行的不是完整 PINN，而是：**用机理模型算一个基线估计，让数据模型去学残差**（并行混合，2.2.1），或者**把机理里会出现的派生量（如焓、转化率）做成特征**（feature engineering，2.2.2）。同时要清醒：**"选哪种混合结构"至今没有理论基础**（2.2.2 原话），所以你必须有实验对比来支撑你的结构选择。

## 工业场景 vs 普通 Kaggle 回归：差别清单

| 维度 | 工业场景（本文描述的流程工业软测量） | 普通 Kaggle 回归 |
| --- | --- | --- |
| 目标任务 | 估计**难以在线测量的质量变量**，用于持续监控和控制（3.1） | 在给定数据集上最小化某个误差指标 |
| 数据来源 | 真实装置历史过程数据：**"量大但信息量低"**（abundant but poor in information，3.4 第 3 步） | 已整理好的公开数据集 |
| 标签可得性 | **首要挑战**：质量变量**每 8 小时或每 24 小时**才测一次（3.5） | 每个样本都有标签 |
| 采样率 | **多速率采样**：输入频率高于输出，需同步、需**降采样**（删样本）（3.4 第 4 步） | 通常已对齐、同频 |
| 数据质量 | 显著扰动、异常值、缺失值、传感器故障、数据传输问题、停车、装置波动（3.4 第 3/6 步）；常用做法是**直接删除异常和缺失样本** | 清洗完毕，缺失值处理规范 |
| 变量选择 | 靠**工艺知识或专家经验**挑输入变量，避免冗余输入以降低复杂度、提升精度；无知识时才用 **LASSO / hybrid LASSO / ridge**（3.4 第 2 步） | 常把全部特征丢进模型让模型自己筛 |
| 建模顺序 | **先建线性模型**，精度不够才上更复杂的统计或 ML 算法（3.4 第 5 步） | 直接上强模型冲榜 |
| 评价指标 | **相关系数**与 **RMSE**，并**加定性分析看估计是否跟随实验室化验数据趋势**（3.4 第 6 步） | 纯定量指标（RMSE/MAE/R²），通常只看榜上分数 |
| 验证方式 | **离线验证**（训练/验证集划分）→ 部署进 **DCS** → **在线验证**（监控一段时间的实际表现）（3.4 第 5/6 步） | 交叉验证或固定 hold-out，训练结束即完成 |
| 部署环境 | 软测量运行在 **DCS（distributed control system）**中，按固定采样间隔出估计，受 **soft sensing time** 约束（3.3） | 离线脚本或 notebook，无实时约束 |
| 计算成本 | 是核心约束：**ELM 最快、GRNN 次之、DNN 最贵**；训练时间与 soft sensing time 分开衡量（3.3） | 通常只看精度，训练慢也能忍 |
| 分布漂移 | 工况随产品需求、原料价格变化；**静态模型精度随时间退化**（3.2、3.5） | 假定训练集与测试集同分布 |
| 模型维护 | 需要持续维护：**用最新数据重训**或 **bias updating**（把输出拉近化验值）；换算法、换训练算法、改初始化、加防过拟合手段（3.4 第 6 步、3.5） | 提交后基本不再维护 |
| 跨工况能力 | **外推能力是硬需求**：数据驱动模型有效性不超出训练条件；机理模型才能外推（2.1、2.2.1） | 一般不做外推要求 |
| 人员与流程 | 团队含**班组操作员、工艺工程师、控制工程师、项目经理**；有**项目章程**和**成本收益分析**（量化成省多少钱）；成功后**移交班组操作员**，**人在回路是关键**（3.4 第 1/7 步） | 个人或小队，无组织流程 |
| 结果的可信度要求 | 估计值要"讲得通"、要在操作范围内，可能进入**控制回路**当测量用（3.4 第 7 步），因此误报有安全和经济后果 | 误差小即可，错误代价低 |
| 发表偏倚 | 作者提醒**并非所有真实工业应用都会发表**，Table 5 的工业使用数可能被低估（3.2） | 榜单本身就是全部可见结果 |

## 论文里提到的公开数据集与方法

> **先说重要的一条：这篇论文没有给出任何"可直接下载的公开数据集"清单。** 我全文检索了 "dataset / data set / benchmark / public / open source / github / Tennessee Eastman" 等词，**没有找到任何公开数据集的名称或下载地址，也没有附录列出数据**。作者明确说这是 problem-driven survey，方法细节外包给参考文献和补充材料（补充材料**不在我抓取到的 HTML 内**，其中 2.1 节提到它讨论 small data problems，4.3 节提到它包含更精确的 RL 背景和 limited data 下的 ML 讨论——**具体内容我未获取，不确定**）。
> 所以下面**分开列**：论文实际提到的**方法**，和论文实际提到的**仿真/装置/案例场景**。

### 一、论文明确提到的方法（按论文 Table 1 的三分组）

**1) 统计学习方法**：PCA（主成分分析）、PLS（偏最小二乘）、CCA（典型相关分析）、FA（因子分析）、ICA（独立成分分析）、GMM（高斯混合模型）、LASSO、LARS（最小角回归）、LR（逻辑回归）、SFA（慢特征分析）、RBC（基于重构的贡献，**仅出现在缩写表**）。另外 1 节还提到 **k-means、Fisher 判别分析、最大似然估计、预测误差法**、以及 **ridge regression（岭回归）**、**hybrid LASSO**（3.4 第 2 步用于变量选择）。

**2) 机器学习与深度学习**：ANN、**MLP**、**RBFNN**、**WNN**、**GRNN**、**ELM**、**ENN**（Elman 网络）、**ESN**（回声状态网络）、**DNNE**（去相关神经网络集成）、**DNN**、**RNN**、**CNN**、**BN**（贝叶斯网络）、**RT**（回归树）、**RVM**（相关向量机）、**SVM**（含 SVR 核方法）、**GPR**（高斯过程回归）、**ANFIS**、**TL**（迁移学习）。
混合建模相关：**串行/并行混合模型**、**hybrid semi-parametric modeling**、**multi-fidelity modeling**、**physics-informed neural networks**、**co-Kriging**、**deep Gaussian processes**、**feature engineering**（举了焓 enthalpy 的例子）、**SINDy**（非线性动力学稀疏辨识）、**ALAMO** 平台、**subspace identification**（子空间辨识）、**gradient-boosted trees**。数学工具：**AIC / BIC**、**混合整数（非线性）规划**、**半无限规划**、**sum-of-squares 优化**、**EM 算法**。

**3) 强化学习与控制方法**：**Q-learning**、**DQN**、**DDPG**、**TD3**、**SAC**、**A3C**、**PPO**、**REINFORCE**、**GVF**、**ADP**（近似动态规划，含 heuristic / dual heuristic / globalized dual heuristic dynamic programming）、**PI²**、**Hamilton-Jacobi-Bellman 方程**、**Bellman 方程**、**offline RL / batch RL**、**transfer learning**、**meta-learning / meta-RL**；控制侧：**MPC（模型预测控制）**、**economic MPC**、**RTO（实时优化）**、**modifier adaptation**、**PID**、**trust region**、**surrogate-based optimization**、**chance constraints**。

### 二、论文明确提到的仿真 / 基准 / 装置 / 案例场景
（**这些是例子和案例，不是可下载的公开数据集**）

- **benchmark**：**Williams benchmark plant**（Cubillos et al. 2007，嵌入 MLP 的并行混合模型用于 RTO）。
- **仿真单元**：**simulated CSTR**、**精馏塔（distillation column，含严格设计、超结构优化）**、**四罐系统（quadruple tank system）**、**级联水箱（cascaded tank system，被称为 RL 最常见的环境）**、**两罐系统（two-tank system，Figure 5 中 RL 调 PI 的流程图）**、**混合三罐系统（hybrid three-tank system）**。
- **生物过程**：**补料分批生物反应器（fed-batch bioreactor）**、**lignocellulosic fermentation（木质纤维素发酵，用 PLS 从光谱数据估葡萄糖浓度）**、**photo-production bioprocess（光生产生物过程，用 SINDy 找动力学的稀疏二次修正）**、**batch polymerization reactor（批式聚合反应器，子空间辨识做并行混合模型的数据部分）**。
- **化工/能源过程**：**polymerization system / polymerization process（聚合系统/过程）**、**moving bed process（移动床过程）**、**Vinyl Acetate monomer process（醋酸乙烯酯单体过程）**、**polyol process（多元醇过程）**、**transesterification process（酯交换过程）**、**optimal catalyst selection（最优催化剂选择）**、**CO₂ 捕集（solvent-based CO₂ capture）**、**integrated carbon capture and conversion（碳捕集与转化）**、**gas compressors load sharing（燃气压缩机负荷分配）**、**solid-oxide fuel cells（固体氧化物燃料电池）**、**primary separation vessel / bitumen recovery（沥青回收）**、**hydraulic fractures（水力压裂，串行混合模型）**、**thin film growth（薄膜生长，串行混合模型耦合 PDE 与随机 PDE）**。
- **其他**：**HVAC control**、**water treatment（水处理）**、**Atari 游戏**（作为 RL 的著名成果被引，不是本领域数据）。
- **文献计量语料库**：2015–2023 年、上述出版社的期刊论文，检索词为 **"soft sensor"、"virtual sensor"、"inferential model"**，最终统计样本 **534 篇**（Table 5 合计；仿真数据 107、工业数据 414、工业实际使用 13）。**这个语料库本身没有作为数据集公开。**

### 三、本文自己报告的量化结果（可直接引用）
- Figure 2（读原图）：软测量应用学科分布——**化学工程 72.12%、生物过程工程 13.78%、机械工程 3.53%、其他 10.58%**。
- Figure 3（读原图）：2015–2023 年发文量逐年上升（2015 约 40 篇 → 2022/2023 约 100–105 篇）；软测量类型占比 **data-driven 91.8%、knowledge-driven 6.5%、hybrid 1.7%**。
- Figure 4（读原图）：**全局软测量 83.21%、自适应软测量 16.79%**（与正文"不到三分之一是自适应"一致）。
- Table 2/3/4/5 的百分比与计数见上文"论文骨架"第 3.2 节。

## 术语表

> 只收录**在抓取到的论文正文/表格中真实出现**的术语。中英对照，按主题分组。最后单列"论文里**没有**出现的词"，避免你被二手资料误导。

**建模范式**
| 英文 | 中文 | 一句话解释 |
| --- | --- | --- |
| process industries | 流程工业 | 论文对化工和生物工业的统称 |
| knowledge-driven / mechanistic / white box | 知识驱动 / 机理 / 白箱 | 靠第一性原理建模，能外推，参数有物理意义 |
| data-driven / black box | 数据驱动 / 黑箱 | 靠历史数据建模，需要更多数据，外推能力弱 |
| hybrid modeling / gray box / block-oriented | 混合建模 / 灰箱 / 分块建模 | 把机理和数据模型结合 |
| hybrid semi-parametric modeling | 混合半参数建模 | 混合模型里数据部分是非参数的 |
| parametric / nonparametric | 参数 / 非参数 | 参数量是否固定；非参数随数据量增长 |
| multi-fidelity modeling | 多保真度建模 | 用低保真（机理）模型 + 高保真（数据）修正 |
| serial / parallel hybrid model | 串行 / 并行混合模型 | 数据模型当机理的输入 / 数据模型修正机理输出 |
| residual | 残差 | 观测值与模型预测值之差；并行混合模型学这个 |
| structural mismatch | 结构性不匹配 | 机理模型形式本身不对，串行方案救不了 |
| extrapolation | 外推 | 在训练条件之外仍能预测的能力 |
| feature engineering | 特征工程 | 造出机理模型里会出现的输入项（如焓） |
| physics-informed neural network (PINN) | 物理信息神经网络 | 把守恒方程作为约束加在神经网络参数上 |
| co-Kriging | 协同克里金 | 机理模型训练的 GP 与过程数据训练的 GP 结合 |
| deep Gaussian process | 深层高斯过程 | 多层 GP 组合，用于多保真度建模 |
| SINDy | 非线性动力学稀疏辨识 | 用稀疏回归从数据中辨识动力学方程 |
| ALAMO | （平台名） | 可对响应变量施加约束、嵌入第一性原理的建模平台 |
| sum-of-squares optimization | 平方和优化 | 一类可处理多项式约束的凸优化技术 |

**软测量**
| 英文 | 中文 | 一句话解释 |
| --- | --- | --- |
| soft sensor | 软测量 | 用易测变量实时估计难测/慢测的质量变量 |
| virtual sensor / inferential model | 虚拟传感器 / 推断模型 | soft sensor 的同义说法（论文的检索同义词） |
| Kalman filter | 卡尔曼滤波 | 论文举的知识驱动型（白箱）软测量例子 |
| quality variable | 质量变量 | 指示产品中间或最终质量的变量（如浓度、纯度） |
| global soft sensor | 全局软测量 | 一个模型覆盖整个操作空间，离线训练、在线估计 |
| local modeling | 局部建模 | 只用邻近样本建模，常见于自适应/JIT 方法 |
| static / time-invariant soft sensor | 静态软测量 | 只用单一操作模式数据，精度会随时间退化 |
| adaptive soft sensor | 自适应软测量 | 用新样本更新参数以对抗退化 |
| just-in-time (JIT) learning | 即时学习 | 收到新样本时临时建局部模型，自适应软测量最常用的策略 |
| multimode soft sensor | 多模态软测量 | 针对多个操作模式建模，应对工况变化 |
| bias updating | 偏差更新 | 用实验室化验值把软测量输出拉回来，最流行的维护手段 |
| virtual sample generation | 虚拟样本生成 | 为输入数据造出估计输出，缓解标签不足 |
| semi-supervised learning | 半监督学习 | 用少量标签 + 大量无标签数据建模 |
| autoencoder / stacked autoencoder / deep belief network | 自编码器 / 堆叠自编码器 / 深度信念网络 | 论文提到的用无标签输入数据提特征的方法 |
| multi-rate sampling | 多速率采样 | 输入与输出采样频率不同，需要同步 |
| down-sampling | 降采样 | 删掉没有对应输出测量的输入样本 |
| offline / online validation | 离线 / 在线验证 | 训练后划分验证集评估 / 部署进 DCS 后监控实际表现 |
| distributed control system (DCS) | 分布式控制系统 | 软测量在线部署、按采样间隔出估计的地方 |
| training time | 训练时间 | 确定模型参数所花的时间 |
| soft sensing time | 软测量时间 | 在线得到一次估计所需的时间 |
| human-in-the-loop | 人在回路 | 班组操作员参与，论文称这是成果落地的关键 |
| correlation coefficient / root mean squared error | 相关系数 / 均方根误差 | 论文点名的两个软测量评价指标 |

**优化、控制与强化学习**
| 英文 | 中文 | 一句话解释 |
| --- | --- | --- |
| model predictive control (MPC) | 模型预测控制 | 用过程模型滚动求解优化来控制的范式 |
| real-time optimization (RTO) | 实时优化 | 在线更新操作点追求经济最优 |
| modifier adaptation | 修正项自适应 | 不改机理模型，只在代价与约束上加修正项 |
| surrogate-based optimization | 代理模型优化 | 用快速模型替代昂贵仿真来做优化 |
| trust region | 信赖域 | 认为代理模型可靠的局部区域，随迭代移动 |
| chance constraints | 机会约束 | 以一定置信度满足的约束，依赖不确定性量化 |
| reinforcement learning (RL) | 强化学习 | 通过与环境交互学习策略的序贯决策方法 |
| Bellman equation / Hamilton-Jacobi-Bellman (HJB) | 贝尔曼方程 / HJB 方程 | RL 与最优控制要解的方程；后者是连续时间版本 |
| approximate dynamic programming (ADP) | 近似动态规划 | 自适应求解 HJB 的一类有模型 RL 方法 |
| PI² (policy improvement with path integrals) | 路径积分策略改进 | 求解随机 HJB 的采样方法，机器人学习数据效率高 |
| model-free / model-based RL | 无模型 / 有模型 RL | 是否显式使用动力学模型 |
| sample efficiency | 样本效率 | 训练一个 agent 需要多少数据 |
| offline RL / batch RL | 离线 / 批量强化学习 | 只用历史数据学策略 |
| transfer learning (TL) | 迁移学习 | 把一个任务学到的知识用到相关新任务 |
| meta-learning / meta-RL | 元学习 / 元强化学习 | "学会学习"，用多个相关系统的经验快速适应新系统 |
| PID / proportional-integral-derivative | 比例-积分-微分控制 | 最底层、最普及的控制器；论文认为它是 RL 的合适试验台 |
| expectation-maximization (EM) | 期望最大化算法 | 贝叶斯网络等模型用来优化参数的迭代算法 |
| hyperparameter | 超参数 | 不由训练自动学、需要人工设定的参数 |
| underfit / overfit | 欠拟合 / 过拟合 | 模型太简单学不到规律 / 太复杂把噪声也学进去 |

**缩写表（Table 1）里出现但正文未展开的词**
| 英文 | 中文 | 说明 |
| --- | --- | --- |
| CCA | 典型相关分析 | 1 节提到在工业中广泛使用 |
| RBC | 基于重构的贡献 | **仅出现在 Table 1 缩写表**，正文未讨论（属过程监控，被排除在范围外） |
| DNNE / ENN / ESN | 去相关神经网络集成 / Elman 网络 / 回声状态网络 | 只在 Table 1、Table 2/3 的统计中出现 |
| GVF | （论文 Table 7 中的 RL 算法缩写） | 出现在 Table 7 的 "Janjua et al. 2023" 一行，正文未展开，**我不确定其全称** |

**论文里没有出现的词（避免被二手资料带偏）**
- **concept drift**：论文**没有用**这个词。它表达同一现象时用的是 "prediction accuracy degrades over time"（3.2）和 "operating conditions may change"（3.5）。你若要用，需说明这是文献通行叫法。
- **digital twin**：**正文没有**；只在我抓到的参考文献标题里出现过一次。
- **公开数据集名称**：论文**没有提到任何一个**（包括常被提到的 Tennessee Eastman 过程）。不确定是因为论文本身没写，还是补充材料里有——补充材料未获取。
- **ChatGPT / 大语言模型**：1.1 节**明确声明超出本文范围**。

## 这篇论文给一个零基础学生的下一步

1. **先把 Table 1 和 Table 5 抄成自己的两页纸，一天内做完。**
 Table 1 是缩写对照表，把它做成一页速查卡；Table 5 是"谁真的进厂了"。同时把 Table 2 和 Table 5 并排放在一起，用荧光笔标出**研究多但工业使用为 0** 的方法（DNN、RNN、PCA、GMM、ELM、ANFIS、BN、TL、ESN）和**研究不算最多但有工业使用**的方法（PLS、SVM、GPR、MLP、WNN、RVM、RT）。这张对照图可以直接给导师看，也构成你选题的坐标系。
2. **用一个月把"必须打赢的 baseline"亲手跑一遍：PLS → 线性回归/ridge → GPR → SVR。**
 依据是 Table 5：有工业使用记录的只有 7 类方法，其中 **PLS 和 SVM 是研究量最大、工业使用也最多的两个**，而 3.4 第 5 步明确说工业界的常规做法是"**先建线性模型，精度不够才上复杂算法**"。所以顺序是：**先 PLS，再线性/岭回归，再 GPR 和 SVR**。深度模型（MLP 甚至 LSTM）放在这四步之后，并且**只有在 baseline 打不过时才作为卖点**。5.87% 的软测量文献用 GPR，且 GPR 有工业使用记录（Table 5：2 篇），它还自带预测方差——对你写"不确定性"相关章节很省力。
3. **把你手上的数据按 3.4 节的七步流程走一遍，并写出每一步的实际数字。**
 特别是：**标签的真实采样间隔是多少小时**（3.5 说质量变量常是每班 8 小时或每 24 小时一个样本）、**输入输出是否多速率**（若是，你现在是怎么同步的？是不是用了降采样在删数据？）、**变量选择是靠工艺知识还是靠 LASSO**（3.4 第 2 步）、**评价除了 RMSE 和相关系数，有没有做"估计是否跟随化验数据趋势"的定性分析**（3.4 第 6 步）。这四条几乎一定能在谈话里问出有价值的回应，也几乎一定是你论文里现在的薄弱环节。
4. **为一个具体的缺口做预研：83.21% 的软测量是静态的，而静态模型注定退化。**
 请把研究问题明确写成"**在小样本 + 工况漂移下，用轻量模型做在线自适应**"，而不是泛泛的"用深度学习做软测量"。技术路线上，论文给了两条现成的对照：**just-in-time 局部建模**（Table 4：局部建模里 PLS 占 31.78%、GPR 占 15.30%、SVR 占 11.77%）和 **bias updating 偏差更新**（3.5 说这是"更流行的"维护手段）。一个高性价比的小课题就是：**在 PLS 或 GPR 上实现 JIT + bias updating，并把它和静态基线做退化条件下的对比**——因为基线弱、动机来自真实统计、算力需求低，很适合零基础起步。
5. **把"机理知识"变成模型的一部分，而不是论文引言里的一段话。**
 最低成本的两种做法是（a）**并行混合**：先写一个粗略的机理/物料平衡估计，让你的数据模型去**学残差**（2.2.1）；(b) **feature engineering**：把机理里会出现的派生量（焓、转化率、累积量）加进特征（2.2.2）。但请注意论文的警告：**并行混合在工况大幅偏离训练集时，精度可能还不如纯机理模型**（2.2.1），以及**"选哪种混合结构"至今缺乏理论基础**（2.2.2）——所以你的实验里**必须有结构对比**（串行 vs 并行 vs 纯数据），不能只声称。
6. **（可选的第六步）如果你想碰强化学习，先从 PID 整定和离线 RL 入手。**
 论文说得很直白：**物理系统上的 RL 实现稀少，多集中在 PID 整定和低维状态/动作空间，级联水箱是最常见的环境**；**仅靠无模型 RL 还不够数据高效、在真实工业应用里尚不可用**。所以现实路径是 **offline RL 用历史数据预训练 + 在线微调**，或**用迁移学习/元学习把一个仿真里训好的策略搬到目标系统**（4.3.3）。**但如果你的目标是"最短时间在软测量上出成果"，建议先不碰 RL。**

## 我读的时候没完全懂的地方

以下是**我作为一个零基础读者读这篇综述时真实卡住的地方**，也是我判断你同样会卡住的地方，附上"该回头看什么"。

1. **串行 vs 并行混合模型的适用性，只能死记，无法推导。**
 我懂了两者的接线方式（Figure 1 的 A/B/C），但"什么情况该用哪个"论文只给了两条经验性判断（串行怕 structural mismatch；并行怕工况大幅偏离），且明确说**这个选择"至今缺乏坚实的理论基础"**（2.2.2）。→ **回头看**：von Stosch et al. 2014（论文 ref [15]，混合模型综述，Figure 1 就是引自它）和 Bradley et al. 2022（ref [25]，论文提到的系统性计算比较）。另外补充材料里关于 small data problems 的讨论我没抓到，**不确定**它是否回答了这个问题。

2. **"hybrid/灰箱"在软测量里的定义和 2.2 的定义对不上。**
 3.1 说灰箱软测量是"用数据驱动方法**估计知识驱动模型的参数**"，但 2.2.1 的串行是"数据模型作为机理模型的**输入**"、并行是"数据模型**修正输出**"。参数估计显然不等于这两者。→ 我的判断是论文把 gray box 当宽泛标签用，**这是我的推断，不是论文的原话**。→ **回头看**：ref [15] von Stosch et al. 2014，它应该给出更细的分类体系。

3. **Table 3 里 "DNN 34.64% 是最大类别" 和正文 "浅层网络多于深度学习" 表面冲突。**
 我的理解是正文在比较**类的合计**（MLP+GRNN+ELM+RBFNN+WNN ≈ 38.1% > DNN 34.64%），而 Table 3 是逐项占比。**这个解释是我自己算出来的，论文没有明说**，所以引用时务必标注你是按"类合计"还是"单项"在说。→ **回头看**：Table 3 的表头原文 "Distribution of various types of ANNs"，以及 Figure 3 左侧那张逐年发文量图（我没有逐项读出每年数值）。

4. **"局部建模的首选是 PLS"（Table 4）背后到底是 JIT 还是滑窗，论文没说清。**
 3.2 只说自适应软测量"**大多数使用 just-in-time 策略**"，Table 4 的标题是 "Distribution of statistical and ML methods in **local modeling** of adaptive soft sensors"。**JIT 和 local modeling 是不是同一件事，论文没有明确定义**。→ **回头看**：ref [51] 和 [53]（论文在 3.2 反复引用这两篇讲软测量的基础文献），以及 3.5 提到的 ref [66]（bias updating）。

5. **Table 5 的"industrial use"到底怎么界定，我不确定。**
 论文只说分三档（simulation data / industrial data / industrial use）并提示**可能存在发表偏倚**，但没有说明"industrial use"的判定标准（是长期投运？是闭路控制？还是仅仅上过现场？）。这直接影响那句"DNN 工业使用为 0"的解读力度。→ **回头看**：3.2 正文与作者自己的实验脚注（脚注 4）。**或者直接写信问作者**——通讯作者邮箱在论文里（bhushan.gopaluni@ubc.ca 与 input@nplawrence.com）。

6. **3.3 节的速度排序混了两种证据，我不确定哪些是实测。**
 正文给的整条排序（ELM 最快 → GRNN → RT/DNNE → RBFNN → MLP/ANFIS/WNN → SVM → BN → RNN → DNN）里，**只有 ELM 最快、GRNN 第二**有脚注 4 的实测支持（作者用工业数据建软测量、独立验证集测试、记录时间）。**其余名次来自文献判断还是同一实验，我读不出来**。→ **回头看**：脚注 4 与 ref [53]、[60]、[61]、[14]。引用这条排序时建议只强调有实测支撑的那两句。

7. **4.1/4.2 节对我（零基础、做软测量）的收益不清楚。**
 我承认这部分我读得最浅。它们依赖 MPC、RTO、modifier adaptation 这些控制背景，而论文自己说"**这类技术缺乏工业或实验层面的实现**"（4.2）。→ 我的处理是**先跳过，只留结论**（工业主流仍是机理模型；数据驱动的控制缺验证）。→ 如果导师要求你懂控制侧，**回头看**：ref [92] modifier adaptation、ref [102] Sutton and Barto 2018（RL 教材）、以及 4.3.3 提到的补充材料里"更精确的 RL 背景"（**我没抓到，不确定内容**）。

8. **补充材料（supplementary material）我完全没看到。**
 论文至少三处指向它：1.1（方法的额外阐述）、2.1（small data problems）、4.3（RL 背景）、4.3.3（limited data 下的 ML）。**本导读覆盖不到这些内容，任何涉及它们的说法我都不确定。**→ **该做什么**：去 arXiv 下载 **TeX Source**（https://arxiv.org/src/2401.13836 ）或期刊版的 supplementary，这是补齐这部分的最直接方式。

9. **图 2/3/4 的数字是我读图得到的，不是正文写的。**
 正文只给图号（"see Figure 2/3/4"），没有把数字写进文字。我下载并阅读了这三张图（biao7.png、biao1.png、biao_ga.png）得到上面的百分比。**如果你要引用，请自己复核一遍图片**，因为读图存在误差风险（尤其 Figure 3 左侧逐年柱状图我没有读出精确每年数值）。→ **回头看**：https://arxiv.org/html/2401.13836v1 的对应图片，或期刊版正式图。

---

### 附：论文实际包含的主要章节标题（arXiv v1，逐字）

```
Abstract
1 Motivation
 1.1 Overview and scope
2 Mathematical modeling approaches
 2.1 Knowledge-driven, data-driven, and hybrid modeling
 2.2 Hybrid modeling paradigms
 2.2.1 Traditional serial and parallel hybrid models
 2.2.2 Emerging trends
3 Soft sensors in process industries
 3.1 Motivation for soft sensing
 3.2 A quantitative overview of soft sensing
 3.3 Computational cost of soft sensors
 3.4 Industry implementation of soft sensors
 3.5 Challenges in soft sensor development
4 Data-driven and hybrid modeling approaches for optimization and control
 4.1 Model-based optimization
 4.2 Model predictive control and real-time optimization
 4.3 Reinforcement learning
 4.3.1 Reinforcement learning for process control
 4.3.2 Practical implementation of reinforcement learning
 4.3.3 Challenges and advances in deep reinforcement learning
5 Discussion
 5.1 Conclusions
Acknowledgements
References
```

表格清单（论文实际的表）：Table 1 缩写表、Table 2 软测量数据驱动方法分布、Table 3 ANN 类型分布、Table 4 自适应软测量局部建模方法分布、Table 5 按工业应用程度的方法分解、Table 6 RL 与数学规划对比、Table 7 过程控制中的无模型深度 RL 应用、Table 8 方法-应用强调度矩阵。
图清单（论文实际的图）：Figure 1 混合模型类型学、Figure 2 软测量应用分布、Figure 3 2015–2023 软测量研究发文量、Figure 4 全局与自适应软测量分布、Figure 5 RL 调 PI 控制器的实验反馈图。

> **注**：以上章节与图表编号对应 arXiv **v1**。发表在 *Control Engineering Practice* 的期刊版（DOI 10.1016/j.conengprac.2024.105841）章节划分可能不同，引用时请以期刊版为准。
