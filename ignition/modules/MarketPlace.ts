

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";



const MarketPlaceModule = buildModule("MarketPlaceModule", (m) => {

  const marketplace = m.contract("SimpleMarketplace");

  return { marketplace };

});

export default MarketPlaceModule;