
let fs = require("fs");

try
{
	let server_all = JSON.parse(fs.readFileSync("./pm2-rosi-servers.json"));
	
	let pm2setup = { apps: [] };
	
	try
	{
		pm2setup = JSON.parse(fs.readFileSync("./pm2-setup.json"));
	}
	catch (e)
	{
		console.log("Creating new pm2-setup.json ... ");
	}
	
	server_all.apps.filter(a => process.argv.indexOf(a.name) > 0 &&
		!pm2setup.apps.find(b => b.name == a.name)).forEach(a => {
		pm2setup.apps.push(a);
	});
	
	fs.writeFileSync("./pm2-setup.json", JSON.stringify(pm2setup, null, 2));	
	return 0;
}
catch(e)
{
	console.error("Error occurred updating manifest: ", e);
	return 1;
}
