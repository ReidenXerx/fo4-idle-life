# IDLM catalog (7 masters)

51 IDLM, 3691 IDLE records, 373 filtered FURN, 65 COBJ products (FURN) ; 0 COBJ produce an IDLM

## Groups (ALL inferred from EDIDs; none in data)

|group|n|examples|placed|
|-|-|-|-|
|robot/Handy chores|10|MrHandyGardening Fallout4.esm:1B19B8; MrHandyMaintenance Fallout4.esm:19D592; MrHandyTrimHedgesIdleMarker Fallout4.esm:068041|63|
|guard/stand|5|NPCMilitaryPoseIdleMarker Fallout4.esm:161F26; SentryBotIdleBlockDoor Fallout4.esm:0B3DBC; NPCMilitaryPoseIdleMarkerChild Fallout4.esm:14EB06|76|
|inspect/tinker/shop|12|NPCStandingExamineIdleMarker Fallout4.esm:14B737; NPCPowerArmorExamineIdleMarker Fallout4.esm:197E67; NPCShoppingIdleMarker Fallout4.esm:01F86D|311|
|cower/held|2|CowerLoopingIdleMarker Fallout4.esm:20C2C4; HeldHostageIdleMarker Fallout4.esm:0A51E4|33|
|use-drug/chem/pipboy|5|NPCUsePipBoy Fallout4.esm:1CB006; NPCUseJet Fallout4.esm:1B9B83; NPCNeedlePrepIdleMarker Fallout4.esm:15EFB8|42|
|other|6|EmptyIdleMarker Fallout4.esm:091C84; DLC04NPCOperatorPreppingRifleIdleMarker DLCNukaWorld.esm:03E634; AssaultronShopkeeperIdleMarker Fallout4.esm:15A402|17|
|dog|1|DogmeatIdleMarkerSniffScratch Fallout4.esm:19FCCA|25|
|patrol/search (mostly)|6|PatrolIdleMarker Fallout4.esm:002CE2; MrHandyPatrolIdleMarker Fallout4.esm:06AAC4; MrHandyPatrolIdleMarkerSandboxable Fallout4.esm:14DD59|12800|
|Smoke|1|NPCSmokeIdleMarker Fallout4.esm:0E210E|418|
|drink|2|DLC04BottleChuggingIdleMarker DLCNukaWorld.esm:053928; SodaDispenserNPCMarker DLCworkshop03.esm:001197|4|
|ghoul|1|DLC04_KK_GhoulPaintedIdleMarker DLCNukaWorld.esm:04A8AD|1|

## IDLM detail (sorted by placed)

### PatrolIdleMarker Fallout4.esm:002CE2  placed=12763  group=patrol/search (mostly) (inferred)
- flags IDLF=8 count=21 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['Fallout4.esm:018AA2', 'DLCNukaWorld.esm:007B9C', 'DLCCoast.esm:001942']
  - Fallout4.esm:13AD5B PatrolFlavors | ENAM=dyn_Flavor | DNAM=RaiderRootBehavior.hkx | parent=None
  - Fallout4.esm:2057D2 PatrolSearching | ENAM=dyn_Flavor | DNAM=RaiderRootBehavior.hkx | parent=None
  - Fallout4.esm:13CB1F PowerArmor_PatrolFlavors | ENAM=dyn_Flavor | DNAM=PowerArmorBehavior.hkx | parent=None
  - Fallout4.esm:13CB20 Supermutant_PatrolFlavors | ENAM=dyn_Flavor | DNAM=SuperMutantBehavior.hkx | parent=None
  - Fallout4.esm:1C19CC YaoGuai_PatrolFlavors | ENAM=DynamicAnim | DNAM=YaoGuaiRootBehaviour.hkx | parent=None
  - Fallout4.esm:1C19D3 FEVHound_PatrolFlavors | ENAM=DynamicAnim | DNAM=FEVHoundBehaviour.hkx | parent=None
  - Fallout4.esm:1C19CD Gorilla_PatrolFlavors | ENAM=DynamicAnim | DNAM=GorillaRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19D4 Behemoth_PatrolFlavors | ENAM=DynamicAnim | DNAM=BehemothRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19CF Brahmin_PatrolFlavors1 | ENAM=DynamicAnim | DNAM=BrahminRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19D7 Brahmin_PatrolFlavors2 | ENAM=DynamicAnim | DNAM=BrahminRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19CE Deathclaw_PatrolFlavors | ENAM=dyn_Activation | DNAM=DeathclawRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19D2 Dogmeat_PatrolFlavors | ENAM=dynamicIdle | DNAM=DogmeatRoot.hkx | parent=None
  - Fallout4.esm:1C19D1 Eyebot_PatrolFlavors | ENAM=DynamicAnim | DNAM=EyeBotRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19D5 FeralGhoul_PatrolFlavors | ENAM=DynamicAnim | DNAM=RootBehavior.hkx | parent=None
  - Fallout4.esm:1C19DA Molerat_PatrolFlavors | ENAM=DynamicAnim | DNAM=MoleratRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19D6 Handy_PatrolFlavors | ENAM=dynamicIdle | DNAM=RobotBehavior.hkx | parent=None
  - Fallout4.esm:1C19D0 Mirelurk_PatrolFlavors | ENAM=DynamicAnim | DNAM=RootBehavior.hkx | parent=None
  - Fallout4.esm:1C19DB MirelurkHunter_PatrolFlavors | ENAM=DynamicAnim | DNAM=MirelurkHunterRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19D9 MirelurkKing_PatrolFlavors | ENAM=DynamicAnim | DNAM=MirelurkKingRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19D8 Radstag_PatrolFlavors | ENAM=DynamicAnim | DNAM=RadStagRootBehavior.hkx | parent=None
  - Fallout4.esm:04F62A RadRoach_PatrolFlavors | ENAM=DynamicAnim | DNAM=RadRoachRootBehavior.hkx | parent=None
### NPCSmokeIdleMarker Fallout4.esm:0E210E  placed=418  group=Smoke (inferred)
- flags IDLF=None count=None timer=None model=None kw=['FurnitureClassRelaxation'] sigs=['EDID', 'KSIZ', 'KWDA', 'OBND', 'QNAM']
- samples: ['Fallout4.esm:018AA2', 'FarHarborExt', 'GNN01']
### NPCStandingExamineIdleMarker Fallout4.esm:14B737  placed=168  group=inspect/tinker/shop (inferred)
- flags IDLF=8 count=3 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['CabotHouse01', 'MassFusion01', 'Fallout4.esm:018AA2']
  - Fallout4.esm:01FA11 MTFlavorShoppingIdleB | ENAM=dyn_DoNotInterrupt | DNAM=RaiderRootBehavior.hkx | parent=None
  - Fallout4.esm:01F86C MTFlavorShoppingIdleA | ENAM=dyn_DoNotInterrupt | DNAM=RaiderRootBehavior.hkx | parent=None
  - Fallout4.esm:1E81AC IdleThinking | ENAM=dyn_Activation | DNAM=RaiderRootBehavior.hkx | parent=None
### NPCMilitaryPoseIdleMarker Fallout4.esm:161F26  placed=58  group=guard/stand (inferred)
- flags IDLF=None count=None timer=None model=None kw=[] sigs=['EDID', 'OBND', 'QNAM']
- samples: ['Fallout4.esm:018AA2', 'PrydwenHull02', 'PrydwenHull01']
### NPCPowerArmorExamineIdleMarker Fallout4.esm:197E67  placed=48  group=inspect/tinker/shop (inferred)
- flags IDLF=8 count=3 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['CambridgePD01', 'ArcJetSystemsExt02', 'ArcjetSystems01']
  - Fallout4.esm:0A4D4F PAMTFlavorShoppingIdleC | ENAM=dyn_DoNotInterrupt | DNAM=PowerArmorBehavior.hkx | parent=None
  - Fallout4.esm:0A4D4E PAMTFlavorShoppingIdleB | ENAM=dyn_DoNotInterrupt | DNAM=PowerArmorBehavior.hkx | parent=None
  - Fallout4.esm:1A6D63 PAMTFlavorShoppingIdleA | ENAM=dyn_DoNotInterrupt | DNAM=PowerArmorBehavior.hkx | parent=None
### NPCShoppingIdleMarker Fallout4.esm:01F86D  placed=43  group=inspect/tinker/shop (inferred)
- flags IDLF=8 count=4 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['BunkerHillExt', 'NukaTownMarket01', 'Yangtze01']
  - Fallout4.esm:01F86C MTFlavorShoppingIdleA | ENAM=dyn_DoNotInterrupt | DNAM=RaiderRootBehavior.hkx | parent=None
  - Fallout4.esm:01FA11 MTFlavorShoppingIdleB | ENAM=dyn_DoNotInterrupt | DNAM=RaiderRootBehavior.hkx | parent=None
  - Fallout4.esm:01FA12 MTFlavorShoppingIdleC | ENAM=dyn_DoNotInterrupt | DNAM=RaiderRootBehavior.hkx | parent=None
  - Fallout4.esm:1E81AC IdleThinking | ENAM=dyn_Activation | DNAM=RaiderRootBehavior.hkx | parent=None
### CowerLoopingIdleMarker Fallout4.esm:20C2C4  placed=33  group=cower/held (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['InstituteConcourse', 'InstituteBioScience', 'InstituteSRB']
  - Fallout4.esm:20AC3C CowerLooping | ENAM=cowerStart | DNAM=RaiderRootBehavior.hkx | parent=None
### NPCUsePipBoy Fallout4.esm:1CB006  placed=25  group=use-drug/chem/pipboy (inferred)
- flags IDLF=8 count=2 timer=5.0 model=None kw=['HasPipboyKeyword'] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'KSIZ', 'KWDA', 'OBND']
- samples: ['Vault81', 'Vault81Entry']
  - Fallout4.esm:1C776C IdlePipboyExamineFemale | ENAM=dyn_Activation | DNAM=RaiderRootBehavior.hkx | parent=None
  - Fallout4.esm:1C776B IdlePipboyExamineMale | ENAM=dyn_Activation | DNAM=RaiderRootBehavior.hkx | parent=None
### DogmeatIdleMarkerSniffScratch Fallout4.esm:19FCCA  placed=25  group=dog (inferred)
- flags IDLF=8 count=2 timer=4.0 model=Markers\DogmeatSniff.nif kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'MODL', 'MODT', 'OBND']
- samples: ['Fallout4.esm:018AA2', 'BradbertonAmphitheater02', 'FortHagenExt']
  - Fallout4.esm:077B35 Dogmeat_Idle_Sniff1 | ENAM=dynamicIdle | DNAM=DogmeatRoot.hkx | parent=None
  - Fallout4.esm:077B36 Dogmeat_Idle_Sniff2 | ENAM=dynamicIdle | DNAM=DogmeatRoot.hkx | parent=None
### MrHandyPatrolIdleMarker Fallout4.esm:06AAC4  placed=25  group=patrol/search (mostly) (inferred)
- flags IDLF=28 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['DLC04GZNukaGalaxy01', 'Fallout4.esm:018AA2', 'DLCCoast.esm:001942']
  - Fallout4.esm:060A88 HandySearch | ENAM=idleSearch | DNAM=RobotBehavior.hkx | parent=None
### MrHandyGardening Fallout4.esm:1B19B8  placed=22  group=robot/Handy chores (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['GraygardenExt', 'PrydwenHull01', 'DLC03Vault118']
  - Fallout4.esm:145DA6 HandyGardening | ENAM=dynamicIdle_Looping_MidArm | DNAM=RobotBehavior.hkx | parent=None
### NPCHoldingClipboardIdleMarker Fallout4.esm:122F9E  placed=20  group=inspect/tinker/shop (inferred)
- flags IDLF=None count=None timer=None model=None kw=[] sigs=['EDID', 'OBND', 'QNAM']
- samples: ['InstituteSRB', 'InstituteRobotics', 'InstituteBioScience']
### NPCUseJet Fallout4.esm:1B9B83  placed=16  group=use-drug/chem/pipboy (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['CharlestownDrugDen', 'BADTFL01', 'BrookesHeadLighthouseExt']
  - Fallout4.esm:1B515D IdleUseJet | ENAM=dyn_Activation | DNAM=RaiderRootBehavior.hkx | parent=None
### MrHandyMaintenance Fallout4.esm:19D592  placed=16  group=robot/Handy chores (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['DLC03Vault118']
  - Fallout4.esm:18A2FD HandyMaintenanceIdle1 | ENAM=dynamicIdle_Looping_MidArm | DNAM=RobotBehavior.hkx | parent=None
### MrHandyTrimHedgesIdleMarker Fallout4.esm:068041  placed=12  group=robot/Handy chores (inferred)
- flags IDLF=24 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['Fallout4.esm:018AA2', 'DLC03Vault118']
  - Fallout4.esm:04AD55 HandyTrimHedge | ENAM=dynamicIdle_Looping_LeftArm | DNAM=RobotBehavior.hkx | parent=None
### MrHandyPatrolIdleMarkerSandboxable Fallout4.esm:14DD59  placed=10  group=patrol/search (mostly) (inferred)
- flags IDLF=12 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['PrydwenHull01', 'DmndSchoolhouse01', 'DLC03Vault118']
  - Fallout4.esm:060A88 HandySearch | ENAM=idleSearch | DNAM=RobotBehavior.hkx | parent=None
### EmptyIdleMarker Fallout4.esm:091C84  placed=10  group=other (inferred)
- flags IDLF=None count=None timer=None model=None kw=[] sigs=['EDID', 'OBND']
- samples: ['ParsonsState03', 'ShawHighSchool01', 'CharlesViewAmphitheaterExt']
### DLC04NPCDiscipleCleaningKnifeIdleMarker DLCNukaWorld.esm:024211  placed=10  group=inspect/tinker/shop (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['DLC04HubFizztopMountainInterior01']
  - DLCNukaWorld.esm:021B0E DLC04CleaningKnife | ENAM=dyn_Activation | DNAM=RaiderRootBehavior.hkx | parent=None
### MrHandyWeldingRightArm Fallout4.esm:1538D9  placed=9  group=robot/Handy chores (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['Vault81', 'PrydwenHull01']
  - Fallout4.esm:1A0E8A HandyWeldingIdle_RightHand | ENAM=dynamicIdle_Looping_RightArm | DNAM=RobotBehavior.hkx | parent=None
### DLC04NPCDisciplePlayingKnifeIdleMarker DLCNukaWorld.esm:024212  placed=9  group=inspect/tinker/shop (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['DLC04HubFizztopMountainInterior01', 'NukaWorldNukaTownUSAGate01']
  - DLCNukaWorld.esm:020187 DLC04PlayingKnife | ENAM=dyn_Activation | DNAM=RaiderRootBehavior.hkx | parent=None
### SentryBotIdleBlockDoor Fallout4.esm:0B3DBC  placed=8  group=guard/stand (inferred)
- flags IDLF=24 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['Fallout4.esm:018AA2', 'DLCCoast.esm:001942', 'DLC03POI33']
  - Fallout4.esm:0B3DBB IdleBlockDoor | ENAM=IdleBlockDoor | DNAM=CreateABotBehavior.hkx | parent=None
### NPCLockpickingMediumHeightIdleMarker Fallout4.esm:0BD694  placed=7  group=inspect/tinker/shop (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['Vault11402', 'GNN01', 'AndrewStation01']
  - Fallout4.esm:0E8641 IdleLockPickingMediumHeight | ENAM=dyn_ActivationLoop | DNAM=RaiderRootBehavior.hkx | parent=None
### NPCMilitaryPoseIdleMarkerChild Fallout4.esm:14EB06  placed=6  group=guard/stand (inferred)
- flags IDLF=None count=None timer=None model=None kw=[] sigs=['EDID', 'OBND', 'QNAM']
- samples: ['PrydwenHull01']
### DLC04NPCOperatorPreppingRifleIdleMarker DLCNukaWorld.esm:03E634  placed=6  group=other (inferred)
- flags IDLF=29 count=None timer=None model=None kw=[] sigs=['EDID', 'IDLF', 'OBND']
- samples: ['DLC04HubOperatorLair01']
### NPCLockpickingLowHeightIdleMarker Fallout4.esm:11B184  placed=4  group=inspect/tinker/shop (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['BADTFL01', 'InstituteConcourse', 'PrydwenHull01']
  - Fallout4.esm:0F5A33 IdleLockPickingLowHeight | ENAM=dyn_ActivationLoop | DNAM=RaiderRootBehavior.hkx | parent=None
### DLC04BottleChuggingIdleMarker DLCNukaWorld.esm:053928  placed=4  group=drink (inferred)
- flags IDLF=12 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['DLC04HubCappysCafe01', 'NukaWorldNukaTownUSAGate01']
  - DLCNukaWorld.esm:04B661 DLC04NPCBeerChug | ENAM=dyn_Activation | DNAM=RaiderRootBehavior.hkx | parent=None
### StandingLoopIdleMarker Fallout4.esm:238F0A  placed=3  group=guard/stand (inferred)
- flags IDLF=24 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['DLCNukaWorld.esm:05293A', 'DLC04SafariWelcomeCenter']
  - Fallout4.esm:238EEA IdleStandInPlaceLoop | ENAM=dyn_ActivationLoop | DNAM=PowerArmorBehavior.hkx | parent=None
### CharGenCodsworthDustIdleMarker Fallout4.esm:17CA33  placed=2  group=robot/Handy chores (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['PrewarPlayerHouse01']
  - Fallout4.esm:17B3B0 HandyUseDuster | ENAM=dynamicIdle_AnimDriven | DNAM=RobotBehavior.hkx | parent=None
### MarcyPatrolIdleMarker Fallout4.esm:02670A  placed=2  group=patrol/search (mostly) (inferred)
- flags IDLF=None count=None timer=None model=None kw=[] sigs=['EDID', 'OBND']
- samples: ['ConcordMuseum01']
### RobotWorkshopMarker Fallout4.esm:249F17  placed=1  group=robot/Handy chores (inferred)
- flags IDLF=8 count=None timer=None model=None kw=['ActorTypeRobot'] sigs=['EDID', 'IDLF', 'KSIZ', 'KWDA', 'OBND']
- samples: ['DLC03Vault118']
### CharGenCodsworthRattleMarker Fallout4.esm:03F8B0  placed=1  group=robot/Handy chores (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['Fallout4.esm:0ADF78']
  - Fallout4.esm:019B69 HandyUseBabyRattle | ENAM=dyn_Activation | DNAM=RobotBehavior.hkx | parent=None
### NPCHandsUpIdleMarker Fallout4.esm:17CA30  placed=1  group=guard/stand (inferred)
- flags IDLF=24 count=None timer=None model=None kw=[] sigs=['EDID', 'IDLF', 'OBND', 'QNAM']
- samples: ['Fallout4.esm:000FEF']
### NPCNeedlePrepIdleMarker Fallout4.esm:15EFB8  placed=1  group=use-drug/chem/pipboy (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND', 'QNAM']
- samples: ['GoodneighborOldStateHouse']
  - Fallout4.esm:164331 IdlePreppingNeedle | ENAM=dyn_Activation | DNAM=RaiderRootBehavior.hkx | parent=None
### MQ101MrCallahanIdleMarker Fallout4.esm:15E91E  placed=1  group=inspect/tinker/shop (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['PrewarVault111']
  - Fallout4.esm:01F86C MTFlavorShoppingIdleA | ENAM=dyn_DoNotInterrupt | DNAM=RaiderRootBehavior.hkx | parent=None
### AssaultronShopkeeperIdleMarker Fallout4.esm:15A402  placed=1  group=other (inferred)
- flags IDLF=None count=None timer=None model=None kw=[] sigs=['EDID', 'OBND', 'QNAM']
- samples: ['Fallout4.esm:054BF8']
### DLC04_KK_GhoulPaintedIdleMarker DLCNukaWorld.esm:04A8AD  placed=1  group=ghoul (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['DLC04KiddieKingdomTunnels01']
  - DLCNukaWorld.esm:04A702 DLC04_GhoulPaintedIdle | ENAM=DynamicAnim | DNAM=RootBehavior.hkx | parent=None
### InspectUpIdleMarker DLCNukaWorld.esm:01B168  placed=1  group=inspect/tinker/shop (inferred)
- flags IDLF=8 count=2 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: ['DLC04HubFizztopMountainInterior01']
  - Fallout4.esm:165773 IdleLookUpInspecting | ENAM=dyn_Activation | DNAM=RaiderRootBehavior.hkx | parent=None
  - Fallout4.esm:1E81AC IdleThinking | ENAM=dyn_Activation | DNAM=RaiderRootBehavior.hkx | parent=None
### MQ206IngramConsoleMarker Fallout4.esm:2305D0  placed=0  group=inspect/tinker/shop (inferred)
- flags IDLF=8 count=3 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: []
  - Fallout4.esm:1A6D63 PAMTFlavorShoppingIdleA | ENAM=dyn_DoNotInterrupt | DNAM=PowerArmorBehavior.hkx | parent=None
  - Fallout4.esm:0A4D4E PAMTFlavorShoppingIdleB | ENAM=dyn_DoNotInterrupt | DNAM=PowerArmorBehavior.hkx | parent=None
  - Fallout4.esm:0A4D4F PAMTFlavorShoppingIdleC | ENAM=dyn_DoNotInterrupt | DNAM=PowerArmorBehavior.hkx | parent=None
### MrHandyTrailerMarker Fallout4.esm:1D1AD0  placed=0  group=robot/Handy chores (inferred)
- flags IDLF=None count=None timer=None model=Markers\HandyTrailerMarker.nif kw=[] sigs=['EDID', 'MODL', 'MODT', 'OBND']
- samples: []
### MrHandyWeldingLeftArm Fallout4.esm:1ACBFA  placed=0  group=robot/Handy chores (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: []
  - Fallout4.esm:18A2FE HandyWeldingIdle_LeftHand | ENAM=dynamicIdle_Looping_LeftArm | DNAM=RobotBehavior.hkx | parent=None
### InstituteGorillaIdleMarker Fallout4.esm:0CFF66  placed=0  group=other (inferred)
- flags IDLF=None count=None timer=None model=None kw=[] sigs=['EDID', 'OBND']
- samples: []
### HeldHostageIdleMarker Fallout4.esm:0A51E4  placed=0  group=cower/held (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: []
  - Fallout4.esm:161F5D IdleHeldHostage | ENAM=dyn_Activation | DNAM=RaiderRootBehavior.hkx | parent=None
### DNPrime_BoS304_PrimePunch01 Fallout4.esm:17EE2A  placed=0  group=other (inferred)
- flags IDLF=28 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: []
  - Fallout4.esm:17A58E IdleLibertyPrimePunchHoleOnGround | ENAM=dyn_Activation | DNAM=LibertyPrimeRootBehavior.hkx | parent=None
### DNPrime_BoS304_PrimeScan01 Fallout4.esm:17EE26  placed=0  group=other (inferred)
- flags IDLF=28 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: []
  - Fallout4.esm:17A58D IdleLibertyPrimeScanArea | ENAM=dyn_Activation | DNAM=LibertyPrimeRootBehavior.hkx | parent=None
### MrHandyTrimHedgesIdleMarker_Workshop Fallout4.esm:10F1E6  placed=0  group=robot/Handy chores (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: []
  - Fallout4.esm:04AD55 HandyTrimHedge | ENAM=dynamicIdle_Looping_LeftArm | DNAM=RobotBehavior.hkx | parent=None
### PatrolIdleMarkerCOPY0000 DLCRobot.esm:0083A1  placed=0  group=patrol/search (mostly) (inferred)
- flags IDLF=8 count=21 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: []
  - Fallout4.esm:13AD5B PatrolFlavors | ENAM=dyn_Flavor | DNAM=RaiderRootBehavior.hkx | parent=None
  - Fallout4.esm:2057D2 PatrolSearching | ENAM=dyn_Flavor | DNAM=RaiderRootBehavior.hkx | parent=None
  - Fallout4.esm:13CB1F PowerArmor_PatrolFlavors | ENAM=dyn_Flavor | DNAM=PowerArmorBehavior.hkx | parent=None
  - Fallout4.esm:13CB20 Supermutant_PatrolFlavors | ENAM=dyn_Flavor | DNAM=SuperMutantBehavior.hkx | parent=None
  - Fallout4.esm:1C19CC YaoGuai_PatrolFlavors | ENAM=DynamicAnim | DNAM=YaoGuaiRootBehaviour.hkx | parent=None
  - Fallout4.esm:1C19D3 FEVHound_PatrolFlavors | ENAM=DynamicAnim | DNAM=FEVHoundBehaviour.hkx | parent=None
  - Fallout4.esm:1C19CD Gorilla_PatrolFlavors | ENAM=DynamicAnim | DNAM=GorillaRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19D4 Behemoth_PatrolFlavors | ENAM=DynamicAnim | DNAM=BehemothRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19CF Brahmin_PatrolFlavors1 | ENAM=DynamicAnim | DNAM=BrahminRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19D7 Brahmin_PatrolFlavors2 | ENAM=DynamicAnim | DNAM=BrahminRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19CE Deathclaw_PatrolFlavors | ENAM=dyn_Activation | DNAM=DeathclawRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19D2 Dogmeat_PatrolFlavors | ENAM=dynamicIdle | DNAM=DogmeatRoot.hkx | parent=None
  - Fallout4.esm:1C19D1 Eyebot_PatrolFlavors | ENAM=DynamicAnim | DNAM=EyeBotRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19D5 FeralGhoul_PatrolFlavors | ENAM=DynamicAnim | DNAM=RootBehavior.hkx | parent=None
  - Fallout4.esm:1C19DA Molerat_PatrolFlavors | ENAM=DynamicAnim | DNAM=MoleratRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19D6 Handy_PatrolFlavors | ENAM=dynamicIdle | DNAM=RobotBehavior.hkx | parent=None
  - Fallout4.esm:1C19D0 Mirelurk_PatrolFlavors | ENAM=DynamicAnim | DNAM=RootBehavior.hkx | parent=None
  - Fallout4.esm:1C19DB MirelurkHunter_PatrolFlavors | ENAM=DynamicAnim | DNAM=MirelurkHunterRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19D9 MirelurkKing_PatrolFlavors | ENAM=DynamicAnim | DNAM=MirelurkKingRootBehavior.hkx | parent=None
  - Fallout4.esm:1C19D8 Radstag_PatrolFlavors | ENAM=DynamicAnim | DNAM=RadStagRootBehavior.hkx | parent=None
  - Fallout4.esm:04F62A RadRoach_PatrolFlavors | ENAM=DynamicAnim | DNAM=RadRoachRootBehavior.hkx | parent=None
### DLC02ArenaPlatformMarker DLCworkshop01.esm:000BDE  placed=0  group=patrol/search (mostly) (inferred)
- flags IDLF=8 count=5 timer=15.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: []
  - Fallout4.esm:13AD5B PatrolFlavors | ENAM=dyn_Flavor | DNAM=RaiderRootBehavior.hkx | parent=None
  - Fallout4.esm:13CB1F PowerArmor_PatrolFlavors | ENAM=dyn_Flavor | DNAM=PowerArmorBehavior.hkx | parent=None
  - DLCworkshop01.esm:000CDE DLC02CreateABotPatrolIdle | ENAM=dyn_Flavor | DNAM=CreateABotBehavior.hkx | parent=None
  - Fallout4.esm:13CB20 Supermutant_PatrolFlavors | ENAM=dyn_Flavor | DNAM=SuperMutantBehavior.hkx | parent=None
  - DLCworkshop01.esm:000CE0 DLC02HandyPatrol | ENAM=dynamicIdle | DNAM=RobotBehavior.hkx | parent=None
### DLC03KasumiThinkIdleMarker DLCCoast.esm:025B1C  placed=0  group=inspect/tinker/shop (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: []
  - Fallout4.esm:01FA11 MTFlavorShoppingIdleB | ENAM=dyn_DoNotInterrupt | DNAM=RaiderRootBehavior.hkx | parent=None
### SodaDispenserNPCMarker DLCworkshop03.esm:001197  placed=0  group=drink (inferred)
- flags IDLF=8 count=3 timer=7.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: []
  - DLCworkshop03.esm:001196 SodaDispenserBaseIdle | ENAM=dyn_ActivationLoop | DNAM=RaiderRootBehavior.hkx | parent=None
  - DLCworkshop03.esm:001198 SodaDispenserDrink | ENAM=dyn_ActivationLoop | DNAM=RaiderRootBehavior.hkx | parent=None
  - DLCworkshop03.esm:001196 SodaDispenserBaseIdle | ENAM=dyn_ActivationLoop | DNAM=RaiderRootBehavior.hkx | parent=None
### DLC04NPCUsePsycho DLCNukaWorld.esm:051041  placed=0  group=use-drug/chem/pipboy (inferred)
- flags IDLF=8 count=1 timer=0.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: []
  - Fallout4.esm:18AB52 IdleUsePsycho | ENAM=dyn_Activation | DNAM=RaiderRootBehavior.hkx | parent=None
### DLC04PickMeUpStationIdleMarker DLCNukaWorld.esm:016134  placed=0  group=use-drug/chem/pipboy (inferred)
- flags IDLF=8 count=3 timer=10.0 model=None kw=[] sigs=['EDID', 'IDLA', 'IDLC', 'IDLF', 'IDLT', 'OBND']
- samples: []
  - Fallout4.esm:18AB52 IdleUsePsycho | ENAM=dyn_Activation | DNAM=RaiderRootBehavior.hkx | parent=None
  - Fallout4.esm:164331 IdlePreppingNeedle | ENAM=dyn_Activation | DNAM=RaiderRootBehavior.hkx | parent=None
  - Fallout4.esm:1B515D IdleUseJet | ENAM=dyn_Activation | DNAM=RaiderRootBehavior.hkx | parent=None

## Marker FURN top 60 by placed (full list in json)

- Fallout4.esm:024572 NPCInvWallLean01 placed=578 ['AnimFurnWallLean', 'FurnitureClassRelaxation', 'FurnitureSpecial', 'FurnitureScaleActorToOne']
- Fallout4.esm:01F74E NpcChairFederalistSit01 placed=541 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation', 'FurnitureScaleActorToOne']
- Fallout4.esm:083907 NpcChairPatioSit01 placed=505 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:0EC7B0 SandboxFeralGhoulSquatEating placed=500 ['AnimFurnFeralGhoulSquatEating']
- Fallout4.esm:051C9D NpcBenchHighTechMetalBenchDirtySit01 placed=488 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:0DF45A NPCBenchParkSit01 placed=487 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:02FBF9 NpcBedGroundSleep01 placed=453 ['AnimFurnFloorBedAnims', 'IsSleepFurniture']
- Fallout4.esm:0D75BC NpcBedSleepingBagSleep01 placed=398 ['AnimFurnFloorBedAnims', 'IsSleepFurniture', 'HC_ObjType_SleepingBag']
- Fallout4.esm:01F484 NpcBenchFederalistSit01 placed=363 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:06F9DC NpcChairPlayerHouseRuinKitchenSit01 placed=296 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:1A6E52 NpcChairHighTechOfficeChairDirtySit01 placed=268 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:0D83CC NpcChairIndustrialMetalOfficeSit01 placed=268 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:01F88B NpcChairFederalistOfficeSit01 placed=259 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:0AE440 NpcChairVaultSit03 placed=231 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:03F432 NpcCouchOfficeSit01 placed=221 ['FurnitureClassRelaxation', 'FurnitureScaleActorToOne', 'AnimFurnChairSitAnims']
- Fallout4.esm:0ED135 SandboxFeralGhoulSquatEatingNight placed=216 ['AnimFurnFeralGhoulSquatEating', 'AnimFurnFeralGhoulNight']
- Fallout4.esm:0F0103 SandboxFeralGhoulSitOnFloorEating placed=212 ['AnimFurnFeralGhoulSitOnFloorEating']
- Fallout4.esm:0E37D3 NpcChairIndustrialMetalDiningSit01 placed=192 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:074BB0 NpcChairPlayerHouseRuinSit01 placed=186 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:1A6B85 NpcCouchLounge01BWeathered01Sit01 placed=161 ['FurnitureClassRelaxation', 'AnimFurnChairSitAnims']
- Fallout4.esm:074BB1 NpcCouchPlayerHouseRuinSit01 placed=160 ['FurnitureClassRelaxation', 'AnimFurnCouch']
- Fallout4.esm:0299C2 NPCInvGroundSit placed=153 ['AnimFurnGroundSitAnims', 'FurnitureClassRelaxation']
- Fallout4.esm:07D5D8 NpcStoolDinerIntSit01 placed=142 ['AnimFurnBarStool', 'AnimFurnAllowEating', 'FurnitureClassRelaxation', 'FurnitureScaleActorToOne']
- Fallout4.esm:0ED134 SandboxFeralGhoulSquatEatingDay placed=138 ['AnimFurnFeralGhoulSquatEating', 'AnimFurnFeralGhoulDay']
- Fallout4.esm:0E7ABC NpcChairSchoolDeskSit01 placed=133 ['AnimFurnSchoolDeskSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:06F9DE NpcChairPlayerHouseRuinKitchenSit03 placed=131 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:12EA9B WorkbenchArmorA placed=126 ['workbencharmor', 'FurnitureForce3rdPerson', 'AnimFurnWorkbenchArmorA', 'FurnitureScaleActorToOne', 'Workbench_General']
- Fallout4.esm:0EA1BA NpcChairModernDomesticSit02 placed=126 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:0EA1B9 NpcChairModernDomesticSit01 placed=125 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:10C3B6 WorkbenchCookingFire placed=119 ['AnimFurnWoodCookingFire', 'FurnitureForce3rdPerson', 'WorkbenchCooking', 'FurnitureScaleActorToOne', 'Workbench_General']
- Fallout4.esm:1411CB NPCEatingNoodlesStanding placed=113 ['AnimFurnEatingNoodlesStanding', 'FurnitureClassRelaxation', 'FurnitureSpecial']
- Fallout4.esm:0B30BC NpcBenchVaultSit01 placed=111 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:17E787 workbenchWeaponsB placed=108 ['FurnitureForce3rdPerson', 'AnimFurnWorkbenchWeapons', 'FurnitureScaleActorToOne', 'Workbench_General']
- Fallout4.esm:07D625 NpcBenchDinerIntBoothSit01WithTable placed=105 ['AnimFurnChairWithTable', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:190CB6 ViciousDogSleepOnGround placed=102 ['IsSleepFurniture', 'FurnitureDogSleep']
- Fallout4.esm:1340D3 NpcBedMetalLay01 placed=102 ['IsSleepFurniture', 'AnimFurnBedAnims']
- Fallout4.esm:01F6A3 NpcCouchFederalistSit01 placed=102 ['FurnitureClassRelaxation', 'AnimFurnChairSitAnims']
- Fallout4.esm:0F370B SMChairInvSit01 placed=99 ['AnimFurnSuperMutantSit']
- Fallout4.esm:089505 NpcBenchChurchSit01 placed=92 ['AnimFurnPraying', 'FurnitureClassRelaxation']
- Fallout4.esm:0EA1BC NpcCouchModernDomesticSit01 placed=91 ['FurnitureClassRelaxation', 'AnimFurnCouch']
- Fallout4.esm:14D090 NpcBedMilitaryCotMattressLay01 placed=90 ['IsSleepFurniture', 'AnimFurnBedAnims']
- Fallout4.esm:1487C1 WorkbenchChemistryB placed=85 ['WorkbenchChemlab', 'FurnitureForce3rdPerson', 'AnimFurnWorkbenchChemistryA', 'FurnitureScaleActorToOne', 'Workbench_General']
- Fallout4.esm:12F2F5 WorkbenchChemistryA placed=83 ['WorkbenchChemlab', 'FurnitureForce3rdPerson', 'AnimFurnWorkbenchChemistryA', 'FurnitureScaleActorToOne', 'Workbench_General']
- Fallout4.esm:0F169E NpcChairVaultSit02NoWait placed=81 ['AnimFurnChairSitAnims', 'FurnitureCantWait', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:05DD9B NPCStandingInvGuardPost placed=80 ['AnimFurnGuardPost', 'FurnitureSpecial', 'AnimSynthCanUse']
- Fallout4.esm:0E2803 SandboxFeralGhoulSitOnFloorEatingNight placed=79 ['AnimFurnFeralGhoulSitOnFloorEating']
- Fallout4.esm:032575 NPCInvChairSit placed=79 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation', 'FurnitureScaleActorToOne']
- Fallout4.esm:157FEB WorkbenchPowerArmor placed=76 ['FurnitureForce3rdPerson', 'PowerArmorWorkbenchKeyword', 'Workbench_General']
- Fallout4.esm:06F9DD NpcChairPlayerHouseRuinKitchenSit02 placed=76 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:14D091 NpcBedHospitalMattressLay01 placed=75 ['IsSleepFurniture', 'AnimFurnBedAnims']
- Fallout4.esm:1A6B6D NpcCouchSet02Weathered1x2Straight01Sit01 placed=73 ['FurnitureClassRelaxation', 'AnimFurnChairSitAnims']
- Fallout4.esm:0D83C4 NpcStoolIndustrialMetalSit01 placed=72 ['AnimFurnBarStool', 'AnimFurnAllowEating', 'FurnitureClassRelaxation', 'FurnitureScaleActorToOne']
- Fallout4.esm:0EA1BB NpcChairModernDomesticSit03 placed=72 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:06FA2E NpcStoolPlayerHouseRuinSit01 placed=72 ['AnimFurnBarStool', 'AnimFurnAllowEating', 'FurnitureClassRelaxation', 'FurnitureScaleActorToOne']
- Fallout4.esm:037739 NPCBusStopSit01 placed=72 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']
- Fallout4.esm:0E2802 SandboxFeralGhoulSitOnFloorEatingDay placed=70 ['AnimFurnFeralGhoulSitOnFloorEating']
- Fallout4.esm:0D9C37 NPCPrisonerFloorSit placed=69 ['AnimFurnPrisonerFloorSit']
- Fallout4.esm:1B40BD NPCHandWarmingStanding placed=68 ['AnimFurnNPCHandWarming']
- Fallout4.esm:17B3A4 workbenchWeaponsA placed=67 ['FurnitureForce3rdPerson', 'AnimFurnWorkbenchWeapons', 'FurnitureScaleActorToOne', 'Workbench_General']
- Fallout4.esm:0DF45C NPCChairMemoryLoungeSit01 placed=67 ['AnimFurnChairSitAnims', 'AnimFurnAllowEating', 'FurnitureClassRelaxation']

## Workshop COBJ -> FURN products

- workshop_co_NpcChairVaultSit03 -> Fallout4.esm:0AE440 NpcChairVaultSit03
- workshop_co_BedHospital -> Fallout4.esm:23C9C5 WorkshopNpcBedHospitalBedLay01
- workshop_co_BedMilitaryCot -> Fallout4.esm:23C9C4 WorkshopNpcBedMilitaryCottLay01
- workshop_co_CraftingCookingStove -> Fallout4.esm:1865B9 WorkbenchCookingStove
- workshop_co_ScrapNpcCouchModernDomesticCleanSit01 -> Fallout4.esm:0FDC8B NpcCouchModernDomesticCleanSit01
- workshop_co_NpcChairHighTechOfficeChairDirtySit01 -> Fallout4.esm:1A6E52 NpcChairHighTechOfficeChairDirtySit01
- workshop_co_NpcStoolDinerIntSit01 -> Fallout4.esm:07D5D8 NpcStoolDinerIntSit01
- workshop_co_NpcStoolIndustrialMetalSit01 -> Fallout4.esm:0D83C4 NpcStoolIndustrialMetalSit01
- workshop_co_NpcStoolStadiumSit01 -> Fallout4.esm:017A7F NpcStoolStadiumSit01
- workshop_co_PlayerHouse_Ruin_Stool03 -> Fallout4.esm:0711B4 NpcStoolPlayerHouseRuinSit03
- workshop_co_PlayerHouse_Ruin_Stool02 -> Fallout4.esm:0711B3 NpcStoolPlayerHouseRuinSit02
- workshop_co_CraftingWeaponA -> Fallout4.esm:17B3A4 workbenchWeaponsA
- workshop_co_Doghouse01 -> Fallout4.esm:1C244E Dogmeat_Doghouse
- workshop_co_CraftingChemsB -> Fallout4.esm:1487C1 WorkbenchChemistryB
- workshop_co_NPCChairMemoryLoungeSit01 -> Fallout4.esm:0DF45C NPCChairMemoryLoungeSit01
- workshop_co_NPCCouchMemoryLoungeSit01 -> Fallout4.esm:0DF459 NPCCouchMemoryLoungeSit01
- workshop_co_NpcCouchOfficeSit01 -> Fallout4.esm:03F432 NpcCouchOfficeSit01
- workshop_co_NpcChairPatioSit01 -> Fallout4.esm:083907 NpcChairPatioSit01
- workshop_co_NpcChairAirplaneSit01 -> Fallout4.esm:149E92 NpcChairAirplaneSit01
- workshop_co_NpcCouchAirplaneSit02 -> Fallout4.esm:149E91 NpcCouchAirplaneSit02
- workshop_co_NpcCouchAirplaneSit01 -> Fallout4.esm:149E61 NpcCouchAirplaneSit01
- workshop_co_NpcBenchFederalistSit01 -> Fallout4.esm:01F484 NpcBenchFederalistSit01
- workshop_co_NpcBenchParkSit01 -> Fallout4.esm:0DF45A NPCBenchParkSit01
- workshop_co_NpcStoolModernDomesticSit01 -> Fallout4.esm:0EA1BD NpcStoolModernDomesticSit01
- workshop_co_NpcCouchModernDomesticSit01 -> Fallout4.esm:0EA1BC NpcCouchModernDomesticSit01
- workshop_co_NpcChairModernDomesticSit03 -> Fallout4.esm:0EA1BB NpcChairModernDomesticSit03
- workshop_co_NpcChairModernDomesticSit02 -> Fallout4.esm:0EA1BA NpcChairModernDomesticSit02
- workshop_co_NpcChairModernDomesticSit01 -> Fallout4.esm:0EA1B9 NpcChairModernDomesticSit01
- workshop_co_NpcCouchFederalistSit01 -> Fallout4.esm:01F6A3 NpcCouchFederalistSit01
- workshop_co_NpcStoolFederalistSit01 -> Fallout4.esm:01F93B NpcStoolFederalistSit01
- workshop_co_NpcChairFederalistOfficeSit01 -> Fallout4.esm:01F88B NpcChairFederalistOfficeSit01
- workshop_co_BedMetal -> Fallout4.esm:18C56F WorkshopNpcBedMetalLay01
- workshop_co_CraftingCookingSpit -> Fallout4.esm:14FBCD WorkbenchCookingSpit
- workshop_co_CraftingPowerArmor -> Fallout4.esm:157FEB WorkbenchPowerArmor
- workshop_co_CraftingChems -> Fallout4.esm:12F2F5 WorkbenchChemistryA
- workshop_co_CraftingArmor -> Fallout4.esm:12EA9B WorkbenchArmorA
- workshop_co_CraftingWeapon -> Fallout4.esm:17E787 workbenchWeaponsB
- workshop_co_CraftingCookingFire -> Fallout4.esm:2476B7 WorkbenchCookingFireWorkshop
- workshop_co_BedSleepingBag -> Fallout4.esm:118F57 WorkshopNpcBedSleepingBagSleep01
- workshop_co_BedVault -> Fallout4.esm:118F4B WorkshopNpcBedVaultLay01
- workshop_co_SleepMattress -> Fallout4.esm:020C40 WorkshopNpcBedGroundSleep01
- co_MS11Workbench -> Fallout4.esm:091FD5 MS11Workbench
- workshop_co_PlayerHouse_Ruin_ChairKitchen03 -> Fallout4.esm:06F9DE NpcChairPlayerHouseRuinKitchenSit03
- workshop_co_PlayerHouse_Ruin_ChairKitchen02 -> Fallout4.esm:06F9DD NpcChairPlayerHouseRuinKitchenSit02
- workshop_co_PlayerHouse_Ruin_Stool01 -> Fallout4.esm:06FA2E NpcStoolPlayerHouseRuinSit01
- workshop_co_PlayerHouse_Ruin_ChairKitchen01 -> Fallout4.esm:06F9DC NpcChairPlayerHouseRuinKitchenSit01
- workshop_co_PlayerHouse_Couch01 -> Fallout4.esm:074BB1 NpcCouchPlayerHouseRuinSit01
- workshop_co_PlayerHouse_Chair01 -> Fallout4.esm:074BB0 NpcChairPlayerHouseRuinSit01
- workshop_co_NPCChairFederalistSit01 -> Fallout4.esm:01F74E NpcChairFederalistSit01
- workshop_co_PicnicTable01 -> Fallout4.esm:1C176D NpcTablePicnicSit01
- workshop_co_BedMattress -> Fallout4.esm:020C40 WorkshopNpcBedGroundSleep01
- DLC01workshop_co_CraftingRobot -> DLCRobot.esm:001F16 WorkbenchRobot
- DLC02workshop_co_WorkshopCageDeathclaw -> DLCworkshop01.esm:000817 DLC02WorkshopCageDeathclaw
- DLC06Workshop_co_CleanFurn_PlayerHouse_Clean_ChairKitchen01 -> DLCworkshop03.esm:00538C DLC06NpcChairPlayerHouseCleanKitchenSit01
- DLC06Workshop_co_CleanFurn_PlayerHouse_Chair01Clean -> Fallout4.esm:04D1CC NpcChairPlayerHouseSit01
- DLC06Workshop_co_CleanFurn_PlayerHouse_Clean_Stool01 -> Fallout4.esm:04D1DF NpcStoolPlayerHouseSit01
- DLC06Workshop_co_CleanFurn_PlayerHouse_Couch01Clean -> Fallout4.esm:04D1D8 NpcCouchPlayerHouseSit01
- workshop_co_NpcChairHighTechOfficeChairCleanSit01 -> DLCworkshop03.esm:005391 DLC06NpcChairHighTechOfficeChairCleanSit01
- DLC06_workshop_co_VaultNpcBedVaultLay02 -> DLCworkshop03.esm:004981 DLC06WorkshopNpcBedVaultLay02
- DLC04workshop_co_Amphitheaterthrone -> DLCNukaWorld.esm:02F326 DLC04_AmphitheaterPropThrone01
- DLC04workshop_co_Patiochair -> DLCNukaWorld.esm:050325 DLC04Workshop_NpcChairPatioSit01_Nuka
- DLC04_co_SodaMixingMachine_Victory -> DLCNukaWorld.esm:04D8E9 DLC04_WorkbenchSodaMachine_Freestanding_Victory
- DLC04_co_SodaMixingMachine_Quartz -> DLCNukaWorld.esm:04D8ED DLC04_WorkbenchSodaMachine_Freestanding_Quartz
- DLC04_co_SodaMixingMachine_Orange -> DLCNukaWorld.esm:017D26 DLC04_WorkbenchSodaMachine_Freestanding_Orange
- DLC04_co_SodaMixingMachine_Quantum -> DLCNukaWorld.esm:04D8E6 DLC04_WorkbenchSodaMachine_Freestanding_Quantum