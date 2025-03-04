using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace iot_data_processor.Validators
{
    internal interface IValidator
    {
        bool Validate(SensorData data);
    }
}
